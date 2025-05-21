#!/bin/sh

original="fussball-tabelle.html"
copy="fussball-tabelle2.html"

if ! test -e "$original"; then
  echo "Urpsrungsdatei konnte nicht gefunden werden"
  exit 1
fi

if test -e "$copy"; then
  rm "$copy"
  sed -e "s:<th\>:<td\>:g" -e "s:</th>:</td>:g"<fussball-tabelle.html >fussball-tabelle2.html
else # Hier werden einfach alle <th\> tags durch <td> und alle </th> durch </td>
  sed -e "s:<th\>:<td\>:g" -e "s:</th>:</td>:g"<fussball-tabelle.html >fussball-tabelle2.html
fi

echo "Differenz der beiden Dateien:"
diff -u "$original" "$copy"

# In welcher Zeile wird der Verein Bayern München gelistet?
grep '/vereine/' $original | \
sed -E 's/.*\/vereine\/([^\/]+)\/2025.*/\1/' | \
sed 's/-/ /g' | \
nl -w1 -s'. '

# Erklärung:
# grep '/vereine/' fussball-tabelle.html | \                                                gibt einen alle zeilen mit dem eintrag "vereine"
# sed -E 's/.*\/vereine\/([^\/]+)\/2025.*/\1/' | \                                          gibt nur das zwischen /vereine/ und /2025 aus
# sed 's/-/ /g' | \                                                                         ersetzt die bindestriche durch leerzeichen
# nl -w1 -s '. '                                                                            nummeriert die zeilen und schreibt einen punkt und ein leerzeichen dahinter
