if [ $# -lt 1 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi


filename="$1"
filetype="$(file "$filename")"

## Unterscheiden :

## Bilddateien : xv
## PDF-Dateien : xpdf
## Textdateien : less
## Open-Document Dateien : libre office



if echo "$filetype" | grep -q ".txt"; then
  echo "$filename is a text file"

less "$filename"


elif echo "$filetype" | grep -q "PDF document"; then
  echo "$filename is a PDF file"


elif echo "$filetype" | grep -q "OpenDocument"; then
  echo "$filename is an OpenDocument file"


elif echo "$filetype" | grep -q "executable"; then
  echo "$filename is an executable file"


else
  echo "$filename is of unknown type"
fi