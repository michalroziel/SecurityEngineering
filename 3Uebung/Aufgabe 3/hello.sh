#!/bin/sh

# -----------------------------------------------
# Prüfen, ob mindestens ein Argument übergeben wurde
# "$#" gibt die Anzahl der Argumente an
# -----------------------------------------------
if [ "$#" -eq 0 ]; then
  echo "Fehler: Bitte mindestens ein Argument angeben."
  exit 1
fi

# -----------------------------------------------
# Schleife über alle übergebenen Argumente
# "$@" steht für alle Argumente als einzelne Strings
# -----------------------------------------------
for name in "$@"; do
  echo "Hallo $name"
done

# Erfolgreich beenden
exit 0
