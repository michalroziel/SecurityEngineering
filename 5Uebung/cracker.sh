#!/bin/bash

  RET_FAIL=1
  RET_SUCCESS=0

  DICT="words.txt"
  USERS=(
      "Steffi.Jones;\$1\$O7v0C21Z\$2FH7ib2Dxtoq6B83qTgON1"
      "Marco.Reus;\$1\$Jebn3vQ5\$2k..iqxtXNwfsCFAamWCS0"
      "Almuth.Schult;\$1\$0ngrMRa1\$uXLzWhnrYzmiRM3fi8Nde1"
      "Manuel.Neuer;\$1\$1aaPttrp\$VoF2rkOyC/tE.DxzQuuIY1"
      "Birgit.Prinz;\$1\$7ieEwjFr\$T/jwatbzqhLZNVDEfymB41"
  )

  # Source the progress bar functions - not needed but cool
  source progress_bar.sh

  # Check if dictionary file exists and is readable
  if [[ ! -r "$DICT" ]]; then
      echo "Error: Cannot access wordlist file!"
      exit $RET_FAIL
  fi

  # Count total words in dictionary
  TOTAL_WORDS=$(wc -l < "$DICT")
  echo "Starting password cracking... (Dictionary contains $TOTAL_WORDS words)"

  for user_entry in "${USERS[@]}"; do
      # Parse user entry
      USERNAME="${user_entry%%;*}"
      PASSWORD_HASH="${user_entry##*;}"

      # Extract salt from hash
      SALT_VALUE=$(echo "$PASSWORD_HASH" | cut -d'$' -f3)

      echo -e "\nProcessing user: $USERNAME"
      echo "Using salt: $SALT_VALUE"
      echo "Checking passwords..."

      PASSWORD_FOUND=0

      # Initialize progress bar
      init_progress_bar $TOTAL_WORDS 10

      # Process each word in dictionary
      while read -r PASSWORD_CANDIDATE; do
          update_progress_bar

          GENERATED_HASH=$(openssl passwd -1 -salt "$SALT_VALUE" "$PASSWORD_CANDIDATE")

          # Compare hashes
          if [[ "$GENERATED_HASH" == "$PASSWORD_HASH" ]]; then
              echo -e "\nSUCCESS: Password for $USERNAME is: $PASSWORD_CANDIDATE"
              PASSWORD_FOUND=1
              break
          fi
      done < "$DICT"

      # Clear progress line
      clear_progress_bar

      # Report if no password found
      if [[ $PASSWORD_FOUND -eq 0 ]]; then
          echo "FAILED: No matching password found for $USERNAME"
      fi
  done

  echo -e "\nPassword cracking operation complete."
  exit $RET_SUCCESS
