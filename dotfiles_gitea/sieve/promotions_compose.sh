#!/bin/bash

# create the domains variable as a list of space-separated, double-quoted domains
# one per line from the promotions_domains.txt file

sort -u -o promotions_domains.txt promotions_domains.txt 

domains=""
while IFS= read -r line; do
    domains+="\"$line\", "
done < <(cat "promotions_domains.txt")
domains="${domains%, }"



sed "s/promotions_domains/${domains}/g" promotions_script.txt 
