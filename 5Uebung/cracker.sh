#!/bin/bash

FAIL_EXIT=1
SUCCESS_EXIT=0

WORDLIST="words.txt"

   ##    Marco.Reus $1$Jebn3vQ5$2k..iqxtXNwfsCFAamWCS0
   ##    Almuth.Schult $1$0ngrMRa1$uXLzWhnrYzmiRM3fi8Nde1
   ##    Manuel.Neuer $1$1aaPttrp$VoF2rkOyC/tE.DxzQuuIY1
   ##    Birgit.Prinz $1$7ieEwjFr$T/jwatbzqhLZNVDEfymB41

USERS=(Steffi.Jones $1$O7v0C21Z$2FH7ib2Dxtoq6B83qTgON1

       )

if [[ ! -r "$WORDLIST" ]]; then
    echo -n "ERROR! File not Found !"
    exit $FAIL_EXIT
fi

  ## BEGIN CRACKING !
  ## FORMAT : NAME;HASH

for entry in "${USERS[@]}"; do

  ## EXTRACT USER AND HASH
  ## https://stackoverflow.com/questions/428109/extract-substring-in-bash
  ## Name : part of entry before semicolon
  ## Hash : part of entry after semicolon
    NAME="${entry%%;*}"
    HASH="${entry##*;}"

    ## SALT is the third part, limited by $.
    ## FIXME -f3
    SALT=$(echo "$HASH" | cut -d'$' -f3)
    TARGET_HASH="$HASH"

    ## BEGIN LOOKING FOR PASSWORD
    echo -e "\n NAME : $NAME \n"
    echo -e "\n SALT : $SALT \n"
    echo -e "Looking for password ! ...\n"

    FOUND=0
    while read -r WORD; do
        ## -r -> raw input --> no escapes etc.
        ## https://www.baeldung.com/linux/read-command
        ## -1 -> MD5
        TEST_HASH=$(openssl passwd -1 -salt "$SALT" "$WORD")

        if [[ "$TEST_HASH" == "$TARGET_HASH" ]]; then

            echo -e "FOUND ! The PASSWORD of $NAME is : $WORD !"
            FOUND=1
            break
        fi
    done < "$WORDLIST"

    if [[ $FOUND -eq 0 ]]; then
        echo -e "${RED}❌ Kein Passwort gefunden für $NAME${NC}"
    fi
done

echo -e "\n✅ Attacke wurde ausgeführt."
exit $SUCCESS_EXIT



