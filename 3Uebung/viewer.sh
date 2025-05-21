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

DATEI="$1"

# Prüfen, ob die Datei existiert und lesbar ist
if [ ! -r "$DATEI" ]; then
    echo "Fehler: Datei '$DATEI' existiert nicht oder ist nicht lesbar."
    exit 1
fi
