#!/bin/sh

# Überprüfen, ob ein Programmname übergeben wurde
if [ "$#" -eq 0 ]; then
    echo "Fehler: Kein Programm angegeben."
    exit 1
elif [ "$#" -gt 1 ]; then
    echo "Fehler: Bitte nur eine Programm angeben."
    echo "Usage: $0 <Programm>"
    exit 1
fi

PROGRAMM="$1"

# Durchsuche alle Pfade in der PATH-Umgebungsvariable
IFS=":"  # Trenner auf ":" setzen
for DIR in $PATH; do
    if [ -x "$DIR/$PROGRAMM" ] && [ ! -d "$DIR/$PROGRAMM" ]; then
        echo "$DIR/$PROGRAMM"
        exit 0
    fi
done

# Falls nichts gefunden wurde
echo "$PROGRAMM not found"
exit 1