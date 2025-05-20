#!/bin/sh

# Schleife über alle Argumente
for name in "$@"; do
    echo "Hallo $name"
done

exit 0

