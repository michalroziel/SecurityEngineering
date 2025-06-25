#!/bin/bash
export CPU_TIME_LIMIT=1     ## 1 Second
export STACK_SIZE_LIMIT=3   ## 3 Kilobyte
export FILE_SIZE_LIMIT=5    ## 5 Kilobyte

    echo "== Testing CPU limit =="
    (   ## start subshell
        ulimit -t $CPU_TIME_LIMIT
        ## create signal handler to catch cpu limit
        ## after limit is exceeded system sends SIGXCPU
        ## to process which triggers the sig handler
        trap 'echo "CPU limit exceeded!"; exit 0' SIGXCPU
        echo "Testing CPU limit..."
        while true; do
            : # Infinite loop to consume CPU
        done
    )

    echo -e "\n== Testing stack limit =="
    (   ## start subshell
        ulimit -s $STACK_SIZE_LIMIT
        echo "Testing stack limit..."
        ## Simple recursive function with no trap (system will show segfault)
        ## function calls itself indefinitely w/o a base case
        ## seg fault -> stack limit is being enforced correctly

        ## no signal handler as in case of seg fault,
        ## SIGSEGV signal
        ## programme execution is terminated directly
        ## and after seg fault programme is in invalid state

        f() { f; }; f
    )

    echo -e "\n== Testing file size limit =="
    (
        ulimit -f $FILE_SIZE_LIMIT
        ## exit 0 stops execution of the subshell
        trap 'echo "File size limit exceeded!"; exit 0' SIGXFSZ

        ## dd used to convert data
        ## dd receives signal 25 (SIGXFSZ) when beyond 5KB
        ## input source is /dev/zero
        ## of - output file is "testfile"
        ## bs - block size of 1KB read/write
        ## count - copy 1024 bytes in total
        ## redirect error message :2>/dev/null

        echo "Testing file size limit..."
        dd if=/dev/zero of=testfile bs=1024 count=1024 2>/dev/null
        rm -f testfile
    )