#!/bin/bash

echo -e "Welcome to the Limit checker !"

## Setting the limits

ulimit -f 1000000

## the limits mean : 
# -f 1000000 : maximum file size is 1GB

echo -e "Limits set successfully !"


