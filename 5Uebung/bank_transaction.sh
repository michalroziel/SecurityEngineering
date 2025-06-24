#!/bin/bash

## bank_transaction
## Usage: ./bank_transaction.sh

## Ignore the system-interrupt ctrl +c to prevent exiting script
trap '' INT
DIR='TAN'

## start an endless loop representing the banking server
while true; do
  echo "----"
  ## read username and TAN from user
  ## break loop if input is over (ctrl + D )
  read -p "Benutzername: " USER || { echo; break; }
  read -p "TAN: " TAN || { echo; break; }
  FILE="$DIR/$USER.list"

  ## Check if user-TAN List exists
  if [ ! -f "$FILE" ]; then
    echo "Zugriff verweigert (unbekannter Benutzer)."
    continue
  fi
  ## Check if TAN List is empty
  if [ ! -s "$FILE" ]; then
    echo "Zugriff verweigert (keine TANs mehr)."
    continue
  fi

  ## read the first line (currently active TAN) from user TAN List
  FIRST=$(head -n 1 "$FILE")
  ## Hash the TAN entered by user
  CHECK=$(echo -n "$TAN" | sha256sum | awk '{print $1}')

  ## compare the post-image of entered TAN with the respective one from the list
  if [ "$CHECK" = "$FIRST" ]; then
    echo "Zugriff gewährt."
  ## remove used TAN (first line of File) from the list
    sed -i '' '1d' "$FILE"
  else
    echo "Zugriff verweigert (falsche TAN)."
  fi
done

exit 0