#!/bin/bash


    ## https://stackoverflow.com/questions/238073/how-to-add-a-progress-bar-to-a-shell-script

    ## Spinner characters
    SPINNER_CHARS="/-\|"
    SPINNER_INDEX=0

    ## Initialize progress bar
    init_progress_bar() {
        TOTAL=$1
        WORDS_CHECKED=0
        UPDATE_INTERVAL=${2:-1000}  # Default to 1000 if not specified
        SPINNER_INDEX=0
        # Initial empty progress bar
        echo -ne "\r[                                                  ] 0% (0/${TOTAL}) "
    }

    ## Update progress bar with spinner
    update_progress_bar() {
        WORDS_CHECKED=$((WORDS_CHECKED + 1))

        ## Show sp2inner for every word (very fast updates)
        if (( WORDS_CHECKED % 50 == 0 )); then
            printf "\b${SPINNER_CHARS:SPINNER_INDEX++:1}"
            (( SPINNER_INDEX >= ${#SPINNER_CHARS} )) && SPINNER_INDEX=0
        fi

        ## Update full progress bar periodically
        if (( WORDS_CHECKED % UPDATE_INTERVAL == 0 )); then
            PERCENT=$((WORDS_CHECKED * 100 / TOTAL))
            BAR_LENGTH=$((PERCENT / 2))
            BAR=""
            for ((i=0; i<BAR_LENGTH; i++)); do
                BAR="${BAR}#"
            done
            for ((i=BAR_LENGTH; i<50; i++)); do
                BAR="${BAR} "
            done
            echo -ne "\r[${BAR}] ${PERCENT}% (${WORDS_CHECKED}/${TOTAL}) "
        fi
    }

    ## Clear progress bar (call when done)
    clear_progress_bar() {
        echo
    }