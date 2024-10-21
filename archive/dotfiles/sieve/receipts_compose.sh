#!/bin/bash

# create the subjects variable as a list of space-separated, double-quoted subject line strings
# one per line from the promotions_subjects.txt file

sort -u -o receipts_subjects.txt receipts_subjects.txt 

subjects=""
while IFS= read -r line; do
    subjects+="\"$line\", "
done < <(cat "receipts_subjects.txt")
subjects="${subjects%, }"

sed "s/receipts_subjects/${subjects}/g" receipts_script.txt