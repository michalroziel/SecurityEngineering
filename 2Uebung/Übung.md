Nr 1

```bash

1)
dd if=/dev/urandom of=testfile bs=1M count=1

2)
ln testfile testlink
> Wenn eins davon verändert wird, wird auch das andere verändert.

3) .tar
tar -cf archive.tar testfile testlink


4) .tar.gz
tar -czf archive.tar.gz testfile testlink


5) .tar.bz2
tar -cjf archive.tar.bz2 testfile testlink


6)
zip archive.zip testfile testlink

tar tvf
unzip -t


```


7) Warum ist die Datei größer:
        Die Archive sind ca. doppelt so groß weil testfile und testlink denselben inhalt speichern aber als separate Einträge archiviert sind.

8) dd if=/dev/zero of=testfile0 bs=1M count=1
Ergebnis: Die Datei ist viel kleiner, z.B. nur wenige Kilobyte. Warum?

    Kompression funktioniert besonders gut bei sich wiederholenden Daten wie Nullen !

    Zufallsdaten aus /dev/urandom lassen sich kaum komprimieren, daher bleibt die Archivgröße fast gleich zur Originalgröße.

9) Sicherheitsrelevanz – ZIP-Bomben

    Eine ZIP-Bombe ist eine bösartige Archivdatei, die beim Entpacken gigantisch viel Speicherplatz beansprucht, obwohl sie selbst sehr klein ist.

    Typisches Beispiel: eine Datei voller Nullen, mehrfach geschachtelt in ZIPs – z.B. eine 42-KB-ZIP-Datei, die beim Entpacken 4.5 Petabyte erzeugt.

    Relevanz:

        Kann Virenscanner, Firewalls oder Archivierungssoftware lahmlegen.

        Abwehrmaßnahmen: Begrenzung des Entpackvolumens, rekursive Tiefe, oder Erkennung sich wiederholender Muster.



# Aufgabe 2 (Systemcalls)
rm = rm removes each specified file.  By default, it does not remove directories.

mv = Rename SOURCE to DEST, or move SOURCE(s) to DIRECTORY.

chmod = chmod changes the file mode
       bits  of each given file according to mode, which can be either a symbolic repre‐
       sentation of changes to make, or an octal number representing the bit pattern for
       the new mode bits.

chown = chown changes the user
       and/or group ownership of each given file.

mkdir = The mkdir utility creates the directories named as operands, in the order specified, using mode “rwxrwxrwx” (0777) as

modified by the current umask(2).

rmdir =The rmdir utility removes the directory entry specified by each directory argument, provided it is empty.

kill = The kill utility sends a signal to the processes specified by the pid operands.

ln = The ln utility creates a new directory entry (linked file) for the file name specified by target_file.  The
     target_file will be created with the same file modes as the source_file.

sleep = The sleep command suspends execution for a minimum of number seconds (the default, or unit s), minutes (unit m), hours
     (unit h), or days (unit d).

wget = GNU Wget is a free utility for non-interactive download of files from the Web.

b) Installationspfade mit which

```bash

/bin/rm
/bin/mv
/bin/chmod
/usr/sbin/chown
/bin/mkdir
/bin/rmdir
kill: shell built-in command
/bin/ln
/bin/sleep
/opt/homebrew/bin/wget
```

```bash
ls bin

[ cp dd expr launchctl mkdir pwd sh tcsh zsh
bash csh df hostname link mv realpath sleep     test cat dash echo kill ln pax rm stty unlink
chmod date ed ksh ls ps rmdir sync wait4path
```

```bash

ls /usr/sbin | wc -l

228

```

### c) Command Examples

rm foo.txt

mv hello.txt myDirectory

chmod +x foo.sh

chown alice:developers report.txt

mkdir myDirectory

rmdir myDirectory

kill 6349

ln -s /usr/src /home/src

sleep 50

 wget https://repo1.maven.org/maven2/com/google/errorprone/error_prone_core/2.37.0/error_prone_core-2.37.0-with-dependencies.jar

### d) System Calls

rm : unlink()

mv : rename() / unlink()

chmod : write(2, "chmod: ", 7chmod: )

chown : chown()

mkdir : mkdirat(AT_FDCWD, "myProgramming", 0777) = 0

rmdir : unlinkat(AT_FDCWD,"myProgramming/", AT_REMOVEDIR ) = 0

kill : kill(15228, SIGTERM)

sleep : nanosleep() oder clock_nanosleep()

wget : socket(), connect(), send(), recv()


# Aufgabe 3 (Inode Informationen)

### stat( ) :
function obtains information about the file pointed to by path.

### lstat( ) :
Ähnlich wie stat( ) außer wenn file ein symbolischer link ist, in diesem Case :
lstat() returns information about the link, while stat() returns information about the file the link references.



### fstat( ) :

Ähnlich wie stat( ), aber anstatt von FileName haben wir FileDescriptor (geöffnete Datei)   

```bash
File Infos for /dev/random:

File type: Character device
File size: 0 bytes
UiD : 0
GiD : 0
Benutzername: root
Zugriffsrechte: 0666 
Last Read Access: 
Thu May  8 00:00:10 2025
Last Inode Modification: 
Wed May  7 23:59:33 2025
Last modified: 
Wed May  7 23:59:33 2025

--- --- --- --- --- --- 

File Infos for /bin/sh: 

File type: Regular file
File size: 101232 bytes
UiD : 0
GiD : 0
Benutzername: root
Zugriffsrechte: 0755 
Last Read Access: 
Tue Oct 22 09:49:20 2024
Last Inode Modification: 
Tue Oct 22 09:49:20 2024
Last modified: 
Tue Oct 22 09:49:20 2024

--- --- --- --- --- --- 

File Infos for /usr/bin/tar: 

File type: Regular file
File size: 195760 bytes
UiD : 0
GiD : 0
Benutzername: root
Zugriffsrechte: 0755 
Last Read Access: 
Tue Oct 22 09:49:20 2024
Last Inode Modification: 
Tue Oct 22 09:49:20 2024
Last modified: 
Tue Oct 22 09:49:20 2024

--- --- --- --- --- --- 

File Infos for /var/spool: 

File type: Directory
File size: 192 bytes
UiD : 0
GiD : 0
Benutzername: root
Zugriffsrechte: 0755 
Last Read Access: 
Tue Oct 22 09:49:20 2024
Last Inode Modification: 
Wed Nov  6 22:46:57 2024
Last modified: 
Tue Oct 22 09:49:20 2024

--- --- --- --- --- --- 

File Infos for /etc/services: 

File type: Regular file
File size: 678260 bytes
UiD : 0
GiD : 0
Benutzername: root
Zugriffsrechte: 0644 
Last Read Access: 
Tue Oct 22 09:49:20 2024
Last Inode Modification: 
Wed Nov  6 22:46:57 2024
Last modified: 
Tue Oct 22 09:49:20 2024

--- --- --- --- --- --- 

File Infos for /tmp/.X11-unix/X0: 

Error retrieving file information: No such file or directory

--- --- --- --- --- --- 



```




# Aufgabe 4 (Message Authentication Codes)

```bash

openssl dgst -sha256 -mac HMAC -macopt \
hexkey:0123456789abcdef8877665544332211 /etc/services

openssl dgst -sha256 -mac HMAC -macopt hexkey:0123456789abcdef8877665544332211 /etc/services


HMAC-SHA2-256(/etc/services)= 05b13297eed6aec708d971a0773335690008cb375c94c288424b366441f361e8

```

HMAC - Hash Based Mac Authentication Code - Verschlüsselter Fingerabdruck
Damit können wir überprüfen, ob die DatenIntegrität eingehalten wurde

Nur wer den Schlüssel Kennt, kann den Code reproduzieren

128 Bits = 32 HEX DIGITS

Bob kennt private Key von Alice und Methode - HMAC (HashMac)

```bash

od -t x4 /dev/urandom | head -1 | cut -c 17- | sed -e "s/ //g"

od - octal dump - immer eindeutig

- t : Format auswählen, x4 : 4 Byte Blöcke  aus /dev/urandom (Zufallszahlen)
- head -1 :  erste Zeile auswählen
- cut -c 17 N-   -> N'th Byte to the end of the Line     -> die ersten 16 Byte werden abgeschnitten


Frage : Warum das cutten von 16 Bytes - 128 Bits am Anfang ?

```

```bash
openssl dgst -sha256 -mac HMAC -macopt hexkey:47bce00df6ccf5b7f2d0d113 dummy.txt
HMAC-SHA2-256(dummy.txt)= abb7f7c3d68914b535ed669887e8b258b3538b6a16b380af180411ff4093edb6

```


