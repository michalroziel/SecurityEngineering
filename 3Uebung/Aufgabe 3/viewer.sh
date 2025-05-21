#!/bin/sh

# -----------------------------------------------
# https://github.com/haegar/xv
# -----------------------------------------------
# 1. Eingabeprüfung
# Prüfen, ob genau ein Argument (Dateiname) übergeben wurde
# -----------------------------------------------

# Keine Datei angegeben
if [ "$#" -eq 0 ]; then
    echo "Fehler: Keine Datei angegeben."
    exit 1

# Zu viele Dateien angegeben
elif [ "$#" -gt 1 ]; then
    echo "Fehler: Bitte nur eine Datei angeben."
    echo "Benutzung: $0 <filename>"
    exit 1
fi

# Speichere Dateinamen aus Argument
filename="$1"

# -----------------------------------------------
# 2. Existenz- und Lesbarkeitsprüfung
# -----------------------------------------------
if [ ! -r "$filename" ]; then
    echo "Fehler: Datei '$filename' existiert nicht oder ist nicht lesbar."
    exit 1
fi

# -----------------------------------------------
# 3. Dateityp bestimmen
# Der Befehl `file` liefert Informationen über den Typ
# -----------------------------------------------
filetype="$(file "$filename")"

# -----------------------------------------------
# 4. Dateityp erkennen und passende Anwendung starten
# -----------------------------------------------

# Textdateien (enthält .txt)
if echo "$filetype" | grep -q ".txt"; then
    echo "$filename ist eine Textdatei"
    less "$filename"

# PDF-Dateien
elif echo "$filetype" | grep -q "PDF document"; then
    echo "$filename ist eine PDF-Datei"
    xpdf "$filename"

# OpenDocument-Dateien (z.B. LibreOffice-Dateien)
elif echo "$filetype" | grep -q "OpenDocument"; then
    echo "$filename ist eine OpenDocument-Datei"
    libreoffice "$filename"

# Bilddateien (z.B. PNG, JPG, etc.)
elif echo "$filetype" | grep -q "image"; then
    echo "$filename ist eine Bilddatei"
    eog "$filename"

# Ausführbare Dateien
elif echo "$filetype" | grep -q "executable"; then
    echo "$filename ist eine ausführbare Datei"
    sh "$filename"

# Unbekannter Typ
else
    echo "$filename ist ein unbekannter Dateityp"
fi
