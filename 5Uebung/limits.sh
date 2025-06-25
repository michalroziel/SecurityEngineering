#!/bin/bash

    echo "== Testing CPU limit =="
    (
        ulimit -t 1
        ## create signal handler to catch cpu limit
        ## after limit is exceeded
        trap 'echo "CPU limit exceeded!"; exit 0' SIGXCPU
        echo "Testing CPU limit..."
        while true; do
            : # Infinite loop to consume CPU
        done
    )

    echo -e "\n== Testing stack limit =="
    (
        ulimit -s 3
        echo "Testing stack limit..."
        ## Simple recursive function with no trap (system will show segfault)
        ## function calls itself indefinitely w/o a base case
        ## seg fault -> stack limit is being enforced correctly
        ## no signal handler as in case of seg fault,
        ## programme execution is terminated directly

        f() { f; }; f
    )

    echo -e "\n== Testing file size limit =="
    (
        ulimit -f 5
        trap 'echo "File size limit exceeded!"; exit 0' SIGXFSZ
        echo "Testing file size limit..."
        dd if=/dev/zero of=testfile bs=1024 count=1024 2>/dev/null
        rm -f testfile
    )