#!/bin/bash

# Comma-separated list of paths to which each of the model gguf files should be symlinked
LINKED_PATHS="/home/joey/Projects/LLMs/models"

IFS="," read -ra DIR <<< "$LINKED_PATHS"
for dir in "${DIR[@]}"; do 
    echo "======== GENERATING SYMLINKS FOR: $dir ========"
    for file in *.gguf; do
        #echo "CMD: ln -s \"$(realpath $file)\" \"$dir/$file\""
        ln -s "$(realpath $file)" "$dir/$file"
    done
done
