# Define paths for Sysmon and Winlogbeat
$sysmonPath = "C:\Program Files\Sysmon"
$winlogbeatPath = "C:\Program Files\Winlogbeat"

# Function to uninstall Sysmon
function Uninstall-Sysmon {
    Write-Host "Uninstalling Sysmon..."
    if (Test-Path "$sysmonPath\sysmon64.exe") {
        Start-Process "$sysmonPath\sysmon64.exe" -ArgumentList '-u' -Wait
        Write-Host "Sysmon uninstalled successfully."
    } else {
        Write-Host "Sysmon not found in the specified path: $sysmonPath"
    }
}

# Function to uninstall Winlogbeat
function Uninstall-Winlogbeat {
    Write-Host "Stopping Winlogbeat service..."
    Stop-Service winlogbeat -ErrorAction SilentlyContinue

    Write-Host "Uninstalling Winlogbeat service..."
    if (Test-Path "$winlogbeatPath\uninstall-service-winlogbeat.ps1") {
        PowerShell.exe -ExecutionPolicy Unrestricted -File "$winlogbeatPath\uninstall-service-winlogbeat.ps1" -Wait
        Write-Host "Verifying Winlogbeat service removal..."
        $winlogbeatService = Get-Service winlogbeat -ErrorAction SilentlyContinue
        if ($null -eq $winlogbeatService) {
            Write-Host "Winlogbeat service removed successfully."
        } else {
            Write-Host "Winlogbeat service still exists."
        }

        Write-Host "Removing Winlogbeat directory..."
        Remove-Item -Recurse -Force $winlogbeatPath
        Write-Host "Winlogbeat directory removed."
    } else {
        Write-Host "Winlogbeat uninstall script not found at: $winlogbeatPath"
    }
}

Write-Host "Starting uninstallation process..."

Uninstall-Sysmon
Uninstall-Winlogbeat

Write-Host "Uninstallation process completed."
