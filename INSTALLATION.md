# Installation

1. Clone repo
2. Installiere Sysmon (auf zu überwachenden Clients)
    - https://learn.microsoft.com/de-de/sysinternals/downloads/sysmon
    - Gehe in verzeichnis
    - Führe `.\sysmon64 -accepteula -i`
3. Installiere Winlogbeat (auf zu überwachenden Clients)
    - Download 7.1.1 (https://www.elastic.co/downloads/past-releases/winlogbeat-7-1-1)
    - Führe Anweisungen gemäß https://www.elastic.co/guide/en/beats/winlogbeat/current/winlogbeat-installation-configuration.html aus
4. Starte docker cluser mit `docker-compose up`
5. Starte Kibana & füge search index hinzu

# TODOs

- Skript schreiben, das Client installs durchführt