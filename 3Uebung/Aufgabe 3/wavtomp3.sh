#!/bin/sh


# Überprüfen, ob ffmpeg installiert ist
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Fehler: ffmpeg ist nicht installiert oder nicht im Pfad."
    exit 1
fi

# Überprüfen, ob genau eine Datei angegeben wurde
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <datei.wav>"
    exit 1
fi

DATEI="$1"

# Prüfen, ob Datei existiert
if [ ! -f "$DATEI" ]; then
    echo "Fehler: Datei '$DATEI' existiert nicht."
    exit 1
fi

# Prüfen, ob die Datei eine WAV-Datei ist
EXT="${DATEI##*.}"
if [ "$EXT" != "wav" ] && [ "$EXT" != "WAV" ]; then
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