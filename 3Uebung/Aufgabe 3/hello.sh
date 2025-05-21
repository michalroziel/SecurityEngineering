#!/bin/sh

# Check ob mindestens ein Argument gegeben ist
if [ "$#" -eq 0 ]; then
  echo "Fehler: Bitte mindestens ein Argument angeben."
  exit 1
fi

# Für jedes Argument "Hallo " + Arugument ausgeben
for name in "$@"; do
  echo "Hallo $name"
done

exit 0


