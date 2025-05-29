# LogAnalysis - für Docker 
In sogenannten Protokoll- oder Logdateien (engl. logfiles) protokolliert jedes Linux-System sämtliche Ereignisse, Probleme und Fehler des Systems sowie laufender Dienste. Diese Informationen werden in unterschiedlichen Textdateien abgelegt, die sich in der Regel im Ordner `/var/log` sowie in angeschlossenen Unterordnern befinden. Das Betrachten dieser Textdateien erfolgt normalerweise in einem beliebigen Editor, der über das Terminal ausgeführt wird. Mit LogAnalysis - für Docker können diese Dateien über eine WebGUI komfortabel betrachtet und durchsucht werden.

## Wichtiger Hinweis
**LogAnalysis - für Docker** befindet sich aktuell noch im **Testbetrieb** weshalb von einem produktiven Einsatz dringend abzuraten ist. Alle sind herzlich dazu eingeladen, sich an der Weiterentwicklung zu beteiligen oder um Wünsche, Fehler und Probleme zu melden.

## Installationshinweise
- Erstelle in deinem lokalen Docker-Verzeichnis ein neues Verzeichnis mit dem Namen `loganalysis`

  **Beispiel:**

  		mkdir -p /volume1/docker/loganalyis

- Wechsle zum LogAnalysis GitHub Repository und klicke entweder auf Releases in der rechten Seitenleiste, um dir alle LogAnalysis-Versionen anzeigen zu lassen, oder klicke direkt darunter auf die aktuellste LogAnalysis-Version.
- Wähle in der Tabelle direkt unter den Release Notes das Paket mit dem Namen `Source Code (zip)` bzw. `Source Code (tar.gz)`, um die Datei herunterzuladen. Als Speicherort wählst du das zuvor bereits angelegte Verzeichnis `loganalysis` aus.
- Wechsle in das Verzeichnis loganalysis innerhalb deines lokalen Docker-Verzeichnises und entpacke dort das heruntergeladene Paket.
- Führe nun das 'Dockerfile' mit Root-Rechten aus, um das Docker-Image zu erstellen. Verwende dafür den folgenden Befehl:

  		sudo docker build -t loganalysis .

- Starte einen neuen Container aus dem gerade erstellten Image, um LogAnalysis auszuführen.

  **Wichtiger Hinweis:** Da sich **LogAnalysis - für Docker** noch im **Testbetrieb** befindet, wird der Container mit einigen zusätzlichen Flags gestartet. Diese werden im Folgenden erläutert. Gegebenenfalls muss außerdem der Port angepasst werden, über den LogAnalysis erreichbar sein soll. In diesem Beispiel wurde der Port 8080 gewählt.

  		sudo docker run -it --rm -d --name LogAnalysis -p 8080:80 -v /var/log:/tmp/log loganalysis
 
   - -i -t (oder -it) ermöglicht den interaktiven Zugriff auf den Container
   - –rm entfernt den Container beim Beenden, um Systemressourcen (CPU, Speicher) freizugeben
   - -d lässt den Container im Hintergrund laufen und druckt die Container-ID

## Hilfe und Diskussion
- Informationen folgen

## Versionsgeschichte
- Details zur Versionsgeschichte finden Sie in der Datei [CHANGELOG](CHANGELOG).

## Entwickler-Information
- Details zum Frontend entnehmen Sie bitte dem [Bootstrap Framework](https://getbootstrap.com/)
- Details zu jQuery entnehmen Sie bitte der [jQuery API](https://api.jquery.com/)

## Lizenz
[MIT-License](LICENSE).

