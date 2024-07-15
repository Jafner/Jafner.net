#!/bin/bash

NAUTILUS_SCRIPTS_DIR="/home/joey/.local/share/nautilus/scripts"
COUNTER=0
SCOUNTER=0
DCOUNTER=0
for file in ./*; do 
    # Get second line of file
    SCRIPT_NAME="$(head -2 $file | tail -1)"
    # Guard statement for script name
    if [[ "$SCRIPT_NAME" == "#[\""* ]]; then 
        NAME="$(echo $SCRIPT_NAME | cut -d'"' -f 2)"
        echo "ln -s $(realpath $file) \"$NAUTILUS_SCRIPTS_DIR/$NAME\""
        ln -s $(realpath $file) "$NAUTILUS_SCRIPTS_DIR/$NAME" && COUNTER=$((COUNTER+1)) || DCOUNTER=$((DCOUNTER+1))
    else
        echo -n "File has no script name (Skipping): "
        echo "$file"
        SCOUNTER=$((SCOUNTER+1))
    fi
done
echo "Created $COUNTER new symlinks ($SCOUNTER skipped, $DCOUNTER duplicates)"