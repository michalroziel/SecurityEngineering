#!/bin/sh

# Wir benutzen ffmpeg, einen universellen Media-Converter

# ----------------------------------------------------
# Prüfen, ob genau eine Datei als Argument übergeben wurde
# "$#" ist die Anzahl der Argumente
# ----------------------------------------------------
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <myFile.wav>"
    exit 1
fi

# Speichere den Dateinamen aus dem ersten Argument in DATEI
DATEI="$1"

# ----------------------------------------------------
# Prüfen, ob die Datei existiert und eine reguläre Datei ist
# -f testet, ob eine Datei existiert und regulär ist (kein Verzeichnis, kein special file)
# ----------------------------------------------------
if [ ! -f "$DATEI" ]; then
    echo "Fehler: Datei '$DATEI' existiert nicht."
    exit 1
fi

# ----------------------------------------------------
# Dateiendung extrahieren mit Parameter Expansion:
# ${DATEI##*.} nimmt alles nach dem letzten Punkt
# Mehr Infos dazu: https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
# ----------------------------------------------------
EXT="${DATEI##*.}"

# ----------------------------------------------------
# Prüfen, ob die Datei die Endung "wav" hat
# Hier nur Kleinschreibung geprüft, ggf. kannst du auch Großschreibung abfangen
# ----------------------------------------------------
if [ "$EXT" != "wav" ]; then
    echo "Fehler: '$DATEI' ist keine WAV-Datei."
    exit 1
fi

# ----------------------------------------------------
# Ziel-Dateiname erstellen, indem .wav durch .mp3 ersetzt wird
# ${DATEI%.*} entfernt die Dateiendung inklusive Punkt
# ----------------------------------------------------
ZIEL="${DATEI%.*}.mp3"

# ----------------------------------------------------
# Ausgabe: Start der Konvertierung
# ----------------------------------------------------
echo "Konvertiere '$DATEI' → '$ZIEL' ..."

# ----------------------------------------------------
# ffmpeg Befehl zum Konvertieren:
# -loglevel error → nur Fehler ausgeben
# -y → vorhandene Zieldatei ohne Nachfrage überschreiben
# -i → Eingabedatei
# -codec:a libmp3lame → MP3 Codec verwenden
# -qscale:a 2 → Qualitätsstufe für MP3 (niedriger Wert = bessere Qualität)
# ----------------------------------------------------
ffmpeg -loglevel error -y -i "$DATEI" -codec:a libmp3lame -qscale:a 2 "$ZIEL"

# ----------------------------------------------------
# Prüfen, ob ffmpeg erfolgreich ausgeführt wurde
# $? enthält den Exitcode des letzten Befehls (0 = Erfolg)
# ----------------------------------------------------
if [ $? -eq 0 ]; then
    echo "Erfolg: '$ZIEL' wurde erstellt."
    exit 0
else
    echo "Fehler bei der Konvertierung von '$DATEI'."
    exit 1
fi