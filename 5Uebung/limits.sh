#!/bin/bash

echo -e "Welcome to the Limit checker !"

## Setting the limits

ulimit -s 16384   ## maximum stack size is 16MB
ulimit -t 30      ## maximum CPU time is 30 seconds
ulimit -f 1000000 ## maximum file size is 1GB

echo -e "Limits set successfully !"


