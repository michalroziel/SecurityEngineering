#!/bin/bash

# generate_tan
# Verwendung: ./generate_tan.sh <Benutzername> <Anzahl>

# Überprüft, ob die korrekte Anzahl an Argumenten (2) übergeben wurde.
if [ $# -ne 2 ]; then
  echo "Verwendung: $0 <Benutzername> <Anzahl>"
  exit 1
fi

# Argumente den Variablen zuweisen.
USER="$1"
COUNT="$2"
DIR='TAN'
USER_TANS_FILE="$USER.tans"
SERVER_LIST_FILE="$DIR/$USER.list"

# Erstellt das Verzeichnis 'TAN', falls es noch nicht existiert.
mkdir -p "$DIR"

# Generiert einen zufälligen 16-Byte-Seed als Startwert für die Kette.
SEED=$(openssl rand -hex 16)
CHAIN=("$SEED")

# Erzeugt eine Kette von Hashes. Jeder neue Hash ist der SHA256-Hash des vorherigen.
for (( i=1; i<=$COUNT; i++ )); do
  CHAIN[$i]=$(echo -n "${CHAIN[$((i-1))]}" | sha256sum | awk '{print $1}')
done

# Leert die Server-Datei und schreibt die Hashes hinein.
>"$SERVER_LIST_FILE"
for (( i=$COUNT; i>0; i-- )); do
  echo "${CHAIN[$i]}" >>"$SERVER_LIST_FILE"
done

# Leert die Benutzer-TAN-Datei und schreibt die Klartext-TANs hinein.
# Dies sind die Werte, die vor dem Hashing kamen (Pre-Images).
>"$USER_TANS_FILE"
echo "Die folgenden TANs wurden in '$USER_TANS_FILE' für den Benutzer $USER gespeichert:"
for (( i=$COUNT-1; i>=0; i-- )); do
  echo "${CHAIN[$i]}"
  echo "${CHAIN[$i]}" >>"$USER_TANS_FILE"
done

echo "Server-Liste wurde in '$SERVER_LIST_FILE' erstellt."

exit 0