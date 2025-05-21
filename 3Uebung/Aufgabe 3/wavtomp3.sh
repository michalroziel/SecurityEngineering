#!/bin/sh

# Wir benutzen ffmpeg, einen universellen media converter

# Überprüfen, ob genau eine Datei angegeben wurde (Anzahl ist 1)
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 < myFile.wav >"
    exit 1
fi

# Unsere Datei als erstes Argument setzen
DATEI="$1"

# Prüfen, ob Datei existiert und "block special file " ist
# -> man test

if [ ! -f "$DATEI" ]; then
    echo "Fehler: Datei '$DATEI' existiert nicht."
    exit 1
fi

# Prüfen, ob die Datei eine WAV-Datei ist
# parameter expansion
#https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
EXT="${DATEI##*.}"
if [ "$EXT" != "wav" ]; then
    echo "Fehler: '$DATEI' ist keine WAV-Datei."
    exit 1
fi

ZIEL="${DATEI%.*}.mp3"

echo "Konvertiere '$DATEI' → '$ZIEL' ..."
ffmpeg -loglevel error -y -i "$DATEI" -codec:a libmp3lame -qscale:a 2 "$ZIEL"

# Erfolg prüfen
if [ $? -eq 0 ]; then
    echo "Erfolg: '$ZIEL' wurde erstellt."
    exit 0
else
    echo "Fehler bei der Konvertierung von '$DATEI'."
    exit 1
fi