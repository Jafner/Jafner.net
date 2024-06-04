#!/bin/bash

for script in ./*_compose.sh; do 
    echo " ==== $script ==== "
    chmod +x $script
    . $script
done
