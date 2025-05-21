#!/bin/sh

sed -n '/id="Abschlusstabelle"/,/<\/table>/p' fussball-tabelle.html |
    grep -o 'href.*'  |
    sed '1d' |
    cut -d'>' -f2- |
    sed 's/<\/a>//g' |
    egrep -n '\*' |
    sed 's/:/. /' |
    sed 's/([A-Za-z])//g' > tabelle.txt