# Define download URLs and file paths
$sysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"
$sysmonDownloadPath = "$env:TEMP\Sysmon.zip"
$sysmonExtractPath = "$env:TEMP\Sysmon"
$sysmonInstallPath = "C:\Program Files\Sysmon"

$winlogbeatUrl = "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-7.1.1-windows-x86_64.zip"
$winlogbeatDownloadPath = "$env:TEMP\Winlogbeat.zip"
$winlogbeatExtractPath = "$env:TEMP\Winlogbeat"
$winlogbeatInstallPath = "C:\Program Files\Winlogbeat"

# Function to download and extract zip files
function Download-And-Extract ($url, $downloadPath, $extractPath) {
    Write-Host "Downloading from $url..."
    Invoke-WebRequest -Uri $url -OutFile $downloadPath

    Write-Host "Extracting to $extractPath..."
    Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force
}

# Function to install Sysmon
function Install-Sysmon {
    Write-Host "Installing Sysmon..."

    # Download and extract Sysmon
    Download-And-Extract $sysmonUrl $sysmonDownloadPath $sysmonExtractPath

    # Install Sysmon with default configuration
    $sysmonExePath = "$sysmonExtractPath\Sysmon64.exe"
    if (Test-Path $sysmonExePath) {
        Start-Process $sysmonExePath -ArgumentList "--accepteula --i" -Wait
        Write-Host "Sysmon installed successfully."

        # Move Sysmon to Program Files
        if (!(Test-Path $sysmonInstallPath)) {
            New-Item -Path $sysmonInstallPath -ItemType Directory
        }
        Move-Item -Path $sysmonExePath -Destination "$sysmonInstallPath\sysmon64.exe" -Force
        Write-Host "Sysmon moved to $sysmonInstallPath"
    } else {
        Write-Host "Sysmon executable not found."
    }
}

# Function to install Winlogbeat
function Install-Winlogbeat {
    Write-Host "Installing Winlogbeat..."

    # Download and extract Winlogbeat
    Download-And-Extract $winlogbeatUrl $winlogbeatDownloadPath $winlogbeatExtractPath

    # Move Winlogbeat to Program Files
    $winlogbeatFiles = Get-ChildItem "$winlogbeatExtractPath\winlogbeat-7.1.1-windows-x86_64"
    if ($winlogbeatFiles) {
        if (!(Test-Path $winlogbeatInstallPath)) {
            New-Item -Path $winlogbeatInstallPath -ItemType Directory
        }
        $winlogbeatFiles | ForEach-Object { Move-Item $_.FullName $winlogbeatInstallPath -Force }
        Write-Host "Winlogbeat files moved to $winlogbeatInstallPath"

        # Install the Winlogbeat service
        $installScript = "$winlogbeatInstallPath\install-service-winlogbeat.ps1"
        if (Test-Path $installScript) {
            PowerShell.exe -ExecutionPolicy Unrestricted -File $installScript -Wait
            Write-Host "Winlogbeat service installed."
        } else {
            Write-Host "Winlogbeat install script not found."
        }
    } else {
        Write-Host "Winlogbeat files not found."
    }
}

# Function to copy winlogbeat.yml configuration file
function Configure-Winlogbeat {
    $configSourcePath = ".\extensions\winlogbeat\config\winlogbeat.yml"
    $configDestinationPath = "$winlogbeatInstallPath\winlogbeat.yml"
    
    if (Test-Path $configSourcePath) {
        Copy-Item -Path $configSourcePath -Destination $configDestinationPath -Force
        Write-Host "winlogbeat.yml configuration file copied to $winlogbeatInstallPath"
    } else {
        Write-Host "Configuration file not found at $configSourcePath."
    }
}

# Main script execution
Write-Host "Starting Sysmon and Winlogbeat installation..."

Install-Sysmon
Install-Winlogbeat
Configure-Winlogbeat

Write-Host "Installation and configuration completed."
