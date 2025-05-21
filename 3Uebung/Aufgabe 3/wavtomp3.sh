#!/bin/sh

# ------------------------------------------------------------
# Prüfen, ob das Programm 'ffmpeg' im System verfügbar ist
# 'command -v' gibt den Pfad zurück, wenn das Kommando existiert
# Umleitung >/dev/null sorgt dafür, dass keine Ausgabe angezeigt wird
# ------------------------------------------------------------
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Fehler: ffmpeg ist nicht installiert oder nicht im Pfad."
    exit 1
fi

# ------------------------------------------------------------
# Prüfen, ob genau ein Argument übergeben wurde
# "$#" gibt die Anzahl der übergebenen Argumente an
# ------------------------------------------------------------
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <datei.wav>"  # Hinweis zur Verwendung
    exit 1
fi

# Speichern des Dateinamens aus dem Argument
DATEI="$1"

# ------------------------------------------------------------
# Prüfen, ob die angegebene Datei überhaupt existiert
# -f prüft, ob es sich um eine reguläre Datei handelt
# ------------------------------------------------------------
if [ ! -f "$DATEI" ]; then
    echo "Fehler: Datei '$DATEI' existiert nicht."
    exit 1
fi

# ------------------------------------------------------------
# Dateiendung extrahieren (alles nach dem letzten Punkt)
# ${DATEI##*.} entfernt alles bis einschließlich dem letzten Punkt
# ------------------------------------------------------------
EXT="${DATEI##*.}"

# ------------------------------------------------------------
# Überprüfen, ob die Datei die Endung .wav oder .WAV hat
# (Groß- und Kleinschreibung wird berücksichtigt)
# ------------------------------------------------------------
if [ "$EXT" != "wav" ] && [ "$EXT" != "WAV" ]; then
    echo "Fehler: '$DATEI' ist keine WAV-Datei."
    exit 1
fi

# ------------------------------------------------------------
# Ziel-Dateiname erstellen, indem die .wav-Endung durch .mp3 ersetzt wird
# ${DATEI%.*} entfernt den letzten Punkt samt allem danach
# ------------------------------------------------------------
ZIEL="${DATEI%.*}.mp3"

# ------------------------------------------------------------
# Konvertierung mit ffmpeg starten
# -loglevel error → nur Fehlermeldungen anzeigen
# -y → existierende Zieldatei ohne Nachfrage überschreiben
# -codec:a libmp3lame → MP3-Codec verwenden
# -qscale:a 2 → Qualitätsstufe 2 (gute Qualität, kleinerer Wert = bessere Qualität)
# ------------------------------------------------------------
echo "Konvertiere '$DATEI' → '$ZIEL' ..."
ffmpeg -loglevel error -y -i "$DATEI" -codec:a libmp3lame -qscale:a 2 "$ZIEL"

# ------------------------------------------------------------
# Überprüfen, ob ffmpeg erfolgreich war
# $? enthält den Exit-Code des zuletzt ausgeführten Befehls (0 = Erfolg)
# ------------------------------------------------------------
if [ $? -eq 0 ]; then
    echo "Erfolg: '$ZIEL' wurde erstellt."
    exit 0
else
    echo "Fehler bei der Konvertierung von '$DATEI'."
    exit 1
fi
