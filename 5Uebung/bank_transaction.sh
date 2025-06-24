#!/bin/bash

# bank_transaction
# Verwendung: ./bank_transaction.sh

# Ignoriert das Interrupt-Signal (STRG+C), um ein Beenden des Skripts zu verhindern.
trap '' INT
DIR='TAN'

# Startet eine Endlosschleife für den Bank-Server.
while true; do
  echo "----"
  # Liest Benutzername und TAN von der Standardeingabe.
  # Bricht die Schleife ab, wenn die Eingabe beendet wird (z.B. mit STRG+D).
  read -p "Benutzername: " USER || { echo; break; }
  read -p "TAN: " TAN || { echo; break; }
  FILE="$DIR/$USER.list"

  # Prüft, ob eine TAN-Liste für den Benutzer existiert.
  if [ ! -f "$FILE" ]; then
    echo "Zugriff verweigert (unbekannter Benutzer)."
    continue
  fi
  # Prüft, ob die TAN-Liste leer ist.
  if [ ! -s "$FILE" ]; then
    echo "Zugriff verweigert (keine TANs mehr)."
    continue
  fi

  # Liest die erste Zeile (die aktuell gültige TAN) aus der Liste des Benutzers.
  FIRST=$(head -n 1 "$FILE")
  # Hasht die vom Benutzer eingegebene TAN.
  CHECK=$(echo -n "$TAN" | sha256sum | awk '{print $1}')

  # Vergleicht den Hash der eingegebenen TAN mit dem erwarteten Hash aus der Datei.
  if [ "$CHECK" = "$FIRST" ]; then
    echo "Zugriff gewährt."
    # Entfernt die benutzte TAN (die erste Zeile) aus der Datei.
    sed -i '1d' "$FILE"
  else
    echo "Zugriff verweigert (falsche TAN)."
  fi
done

exit 0