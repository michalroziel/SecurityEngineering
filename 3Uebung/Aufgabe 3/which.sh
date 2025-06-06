#!/bin/sh
# ----------------------------------------------------------
# Überprüfen, ob genau ein Argument übergeben wurde
# "$#" ist die Anzahl der übergebenen Argumente
# ----------------------------------------------------------

if [ "$#" -eq 0 ]; then
    echo "Fehler: Kein Programm angegeben."
    exit 1  # Beenden, wenn kein Argument übergeben wurde

elif [ "$#" -gt 1 ]; then
    echo "Fehler: Bitte nur ein Programm angeben."
    echo "Usage: $0 <Programm>"  # Anleitung zur Nutzung
    exit 1
fi

# Speichern des übergebenen Programmnamens in einer Variable
PROGRAMM="$1"

# ----------------------------------------------------------
# PATH-Umgebungsvariable enthält alle Verzeichnisse,
# in denen nach ausführbaren Programmen gesucht wird.
# Diese Verzeichnisse sind durch ":" getrennt.
# IFS=":" setzt den internen Feldtrenner auf ":",
# damit die Schleife korrekt durch jeden einzelnen Pfad läuft.
# ----------------------------------------------------------
# https://bash.cyberciti.biz/guide/$IFS
# ----------------------------------------------------------

IFS=":"  # IFS = Internal Field Separator
## Nun können wir die PATH mit foreach durchlaufen

# Durchlaufe jedes Verzeichnis im PATH
for DIR in $PATH; do

    # Prüfen, ob die Datei im Verzeichnis existiert UND ausführbar ist
    # UND keine Verzeichnis ist
    # man test :  -d file True if file exists and is a directory.
    # man test :  -x file True if file exists and is executable.  True indicates only that the execute flag is on.
    # If file is a directory, true indicates that file can be searched.

    if [ -x "$DIR/$PROGRAMM" ] && [ ! -d "$DIR/$PROGRAMM" ]; then
        echo "$DIR/$PROGRAMM"  # Gefunden → gib den vollständigen Pfad aus
        exit 0  # Erfolgreich beenden
    fi
done

# ----------------------------------------------------------
# Wenn kein passendes ausführbares Programm gefunden wurde,
# gib eine entsprechende Fehlermeldung aus
# ----------------------------------------------------------
echo "$PROGRAMM not found"
exit 1  # Fehlerstatus zurückgeben
