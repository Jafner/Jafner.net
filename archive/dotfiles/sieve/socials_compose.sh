#!/bin/bash

# create the domains variable as a list of space-separated, double-quoted domains
# one per line from the socials_domains.txt file

sort -u -o socials_domains.txt socials_domains.txt 

domains=""
while IFS= read -r line; do
    domains+="\"$line\", "
done < <(cat "socials_domains.txt")
domains="${domains%, }"

sed "s/socials_domains/${domains}/g" socials_script.txt 