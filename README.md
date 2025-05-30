# LogAnalysis *für Docker* 
In sogenannten Protokoll- oder Logdateien (engl. logfiles) protokolliert jedes Linux-System sämtliche Ereignisse, Probleme und Fehler des Systems sowie laufender Dienste. Diese Informationen werden in unterschiedlichen Textdateien abgelegt, die sich in der Regel im Ordner `/var/log` sowie in angeschlossenen Unterordnern befinden. Das Betrachten dieser Textdateien erfolgt normalerweise in einem beliebigen Editor, der über das Terminal ausgeführt wird. Mit **LogAnalysis *für Docker*** können diese Dateien über eine WebGUI komfortabel betrachtet und durchsucht werden.

## Wichtiger Hinweis
**LogAnalysis *für Docker*** befindet sich aktuell noch im **Testbetrieb** weshalb von einem produktiven Einsatz dringend abzuraten ist. Alle sind herzlich dazu eingeladen, sich an der Weiterentwicklung zu beteiligen oder um Wünsche, Fehler und Probleme zu melden.

## Installationshinweise
- Wechsle zum GitHub-Repository **LogAnalysis *für Docker*** und klicke entweder auf **Releases** in der rechten Seitenleiste, um dir alle Versionen von LogAnalysis anzeigen zu lassen, oder klicke direkt darunter auf die **aktuellste Version**.
- Wähle in der Tabelle direkt unter den Release Notes das Archiv mit dem Namen **Source Code (zip)** oder **Source Code (tar.gz)**, um die jeweilige Datei herunterzuladen. 
- Nachdem das gewünschte Archiv heruntergeladen wurde, muss es mit einem geeigneten Programm entpackt werden, sofern das verwendete Betriebssystem über keine integrierte Funktion verfügt. Dabei ist darauf zu achten, dass das Archiv in einem neuen Unterverzeichnis entpackt wird, das den Namen der Archivdatei trägt.
- Wechsel anschließend in das lokale Docker-Verzeichnis und erstelle dort ein neues Unterverzeichnis mit dem Namen **loganalysis**. 

  **Beispiel:**

  	  mkdir -p /volume1/docker/loganalysis

- Kopiere den Inhalt des zuvor enpackten Archives in dieses Unterverzeichnis.

  **Beispiel:**

  	  cp -r ~/Downloads/Docker_LogAnalysis-0.1-100/* /volume1/docker/loganalysis

- Wechsle nun in das Unterverzeichnis **loganalysis** deines Docker-Verzeichnisses und führe das "Dockerfile" mit Root-Rechten aus, um das Docker-Image zu erstellen. Verwende dafür den folgenden Befehl:

  	  sudo docker build -t loganalysis .

- Starte einen neuen Container aus dem gerade erstellten Image, um LogAnalysis auszuführen. Verwende dafür den folgenden Befehl:

  	  sudo docker run -it -d --name LogAnalysis -p 8080:80 -v /var/log:/tmp/log loganalysis
 
  **Wichtiger Hinweis:** Gegebenenfalls muss der Port angepasst werden, über den LogAnalysis erreichbar sein soll. In diesem Beispiel wurde der Port 8080 gewählt.
 
- Nach dem erfolgreichen Start des Containers ist dieser über folgende Adresse erreichbar:

  **Beispiel:**

      http://IP-ADRESSE:8080

## Hilfe und Diskussion
- Synology Forum:  
[LogAnalysis - GUI zum betrachten und durchsuchen von /var/log](https://www.synology-forum.de/threads/loganalysis-gui-zum-betrachten-und-durchsuchen-von-var-log.107180/)
- UGREEN Forum - DACH Community:  
[LogAnalysis - für Docker (ein erster Versuch)](https://ugreen-forum.de/forum/thread/887-loganalysis-f%C3%BCr-docker-ein-erster-versuch/)

## Versionsgeschichte
- Details zur Versionsgeschichte finden Sie in der Datei [CHANGELOG](CHANGELOG).

## Entwickler-Information
- [Docker](https://www.docker.com/)
- [Apache](https://httpd.apache.org/)
- [Bootstrap Framework](https://getbootstrap.com/)
- [jQuery API](https://api.jquery.com/)

## Lizenz
[MIT-License](LICENSE).

