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
## pre-image values
USER_TANS_FILE="$USER.tans"
## server list file with post-images (hashed files)
SERVER_LIST_FILE="$DIR/$USER.list"

## Erstellt das Verzeichnis 'TAN', falls es noch nicht existiert.
mkdir -p "$DIR"

## Generiert einen zufälligen 16-Byte-Seed als Startwert für die Kette.
SEED=$(openssl rand -hex 16)
CHAIN=("$SEED")

## Erzeugt eine Kette von Hashes. Jeder neue Hash ist der SHA256-Hash des vorherigen.

## https://stackoverflow.com/questions/3358420/generating-a-sha-256-hash-from-the-linux-command-line
## iteratively compute hashes
## each hash is derived from the previous one :
## S1=Seed, S2=F(S1), S3=F(S2), S4=F(S3), ...S[n]=F(S[n-1])
## https://www.infoworld.com/article/2178307/lamport-s-one-time-password-algorithm-or-don-t-talk-to-complete-strangers.html

for (( i=1; i<=$COUNT; i++ )); do
  CHAIN[$i]=$(echo -n "${CHAIN[$((i-1))]}" | sha256sum | awk '{print $1}')
done

## Leert die Server-Datei und schreibt die Hashes hinein.
## truncate file to zero length by passing empty output
>"$SERVER_LIST_FILE"
## Iterative COUNT-times and write hashes into server file
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