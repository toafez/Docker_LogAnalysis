# LogAnalysis *für Docker* 
### Docker WebGUI zum Betrachten und Durchsuchen von /var/log des Host-Systems
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

## Container Anzeigen, starten, stoppen und löschen
**Hinweis 1:** Wenn man nicht als Systembenutzer **root** an der Kommandozeile angemeldet ist, muss jedem nachfolgenden Befehl `sudo` vorangestellt werden.

**Hinweis 2:** In den nachfolgenden Beispielen müssen selbstverständlich die eigenen, ermittelten Angaben zur Container-ID bzw. zum Container-Namen eingesetzt werden.

- ### Laufende Container anzeigen
  Mit dem Befehl `docker ps` werden **alle** aktuell ausgeführten Container aufgelistet. Die nachfolgende Ausgabe wird dabei auf den LogAnalysis-Container **beschränkt**.

      sudo docker ps  
      CONTAINER ID  IMAGE        COMMAND                 CREATED         STATUS         PORTS                                  NAMES
      a6a7a3770ccc  loganalysis  "/usr/sbin/apache2ct…"  19 minutes ago  Up 19 minutes  0.0.0.0:8080->80/tcp, :::8080->80/tcp  LogAnalysis


  Um sich alle vorhandenen Container anzeigen zu lassen, muss der Befehl `docker ps` um den Parameter `-a` (für all) ergänzt werden.

      sudo docker ps -a 

  Um einen Container zu einem späteren Zeitpunkt zu starten, zu stoppen oder zu löschen, ist vor allem die **Container-ID [CONTAINER ID]** oder der **Container-Name [NAMES]** wichtig.

- ### Container starten
  Ein Container kann mit dem Befehl `docker start` unter der Angabe der zuvor ermittelten Container-ID bzw. des Container-Namens gestartet werden.

  **Beispiel**

      sudo docker start a6a7a3770ccc

- ### Container stoppen
  Ein Container kann mit dem Befehl `docker stop` unter der Angabe der zuvor ermittelten Container-ID bzw. des Container-Namens angehalten bzw. gestoppt werden.

  **Beispiel**

      sudo docker stop a6a7a3770ccc

- ### Container löschen
  Ein Container kann mit dem Befehl `docker rm` unter der Angabe der zuvor ermittelten Container-ID bzw. des Container-Namens gelöscht werden. Dabei ist zu beachten, dass der Container zuvor gestoppt wurde.

  **Beispiel**

      sudo docker rm a6a7a3770ccc

  Ein Container sollte immer dann gelöscht werden, wenn er entweder nicht mehr benötigt wird, oder wenn eine neuere Build-Version des Containers verfügbar ist, um daraus ein neues Image, wie weiter oben beschrieben, zu erstellen und auszuführen.

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

