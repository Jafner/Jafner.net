#!/bin/bash

# create the domains variable as a list of space-separated, double-quoted domains
# one per line from the subscriptions_domains.txt file

sort -u -o subscriptions_domains.txt subscriptions_domains.txt 

domains=""
while IFS= read -r line; do
    domains+="\"$line\", "
done < <(cat "subscriptions_domains.txt")
domains="${domains%, }"

sed "s/subscriptions_domains/${domains}/g" subscriptions_script.txt 