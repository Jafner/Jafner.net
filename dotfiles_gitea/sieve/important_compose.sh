#!/bin/bash

# create the domains variable as a list of space-separated, double-quoted domains
# one per line from the important_domains.txt file

sort -u -o important_domains.txt important_domains.txt 

domains=""
while IFS= read -r line; do
    domains+="\"$line\", "
done < <(cat "important_domains.txt")
domains="${domains%, }"

sed "s/important_domains/${domains}/g" important_script.txt 