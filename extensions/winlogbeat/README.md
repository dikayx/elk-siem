# Winlogbeat

Winlogbeat is a lightweight agent that forwards Windows event logs to Logstash or Elasticsearch. It comes with a default configuration that listens on port 5044 for incoming Beats connections. This guide will show you how to install and configure Winlogbeat to forward Windows event logs to Logstash.

## Installation

> Make sure you have installed Sysmon on the Windows clients you want to monitor. You can download Sysmon from the [official website](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon) where you can also find instructions on how to install it (basically just run `sysmon64.exe -accepteula -i` from the directory where you extracted the files).

1. Download version 7.1.1 of Winlogbeat from the [official website](https://www.elastic.co/downloads/past-releases/winlogbeat-7-1-1)
2. Extract the contents of the zip file to `C:\Program Files\Winlogbeat`
3. Open PowerShell as an administrator and navigate to the Winlogbeat directory
4. Run the following command to install Winlogbeat as a service:

    ```powershell
    powershell -ExecutionPolicy Unrestricted -File .\install-service-winlogbeat.ps1
    ```

## Configuration

You can find the default configuration file at `C:\Program Files\Winlogbeat\winlogbeat.yml`. Copy the [winlogbeat.yml](config/winlogbeat.yml) file from this repository to the Winlogbeat directory and replace the existing file. It is already configured to forward Windows event logs to Logstash on `localhost:5044`.

## Starting Winlogbeat

After you have installed Winlogbeat and configured it, you can start the service by running the following command:

```powershell
Start-Service winlogbeat
```

## See also

[Official Winlogbeat installation guide](https://www.elastic.co/guide/en/beats/winlogbeat/current/winlogbeat-installation-configuration.html)
