#!/bin/sh

# Check Fehlerhafte Eingabe
if [ "$#" -eq 0 ]; then
    echo "Fehler: Keine Datei angegeben."
    exit 1
elif [ "$#" -gt 1 ]; then
    echo "Fehler: Bitte nur eine Datei angeben."
    echo "Usage: $0 <filename>"
    exit 1
fi

filename="$1"

# Prüfen, ob die Datei existiert und lesbar ist
if [ ! -r "$filename" ]; then
    echo "Fehler: Datei '$filename' existiert nicht oder ist nicht lesbar."
    exit 1
fi

filetype="$(file "$filename")"

## Unterscheiden :

## Bilddateien : xv
## PDF-Dateien : xpdf
## Textdateien : less
## Open-Document Dateien : libre office


if echo "$filetype" | grep -q ".txt"; then
  echo "$filename is a text file"

less "$filename"


elif echo "$filetype" | grep -q "PDF document"; then
  echo "$filename is a PDF file"

  xpdf "$filename"


elif echo "$filetype" | grep -q "OpenDocument"; then
  echo "$filename is an OpenDocument file"

  libreoffice "$filename"


elif echo "$filetype" | grep -q "executable"; then
  echo "$filename is an executable file"

  sh "$filename"


else
  echo "$filename is of unknown type"
fi