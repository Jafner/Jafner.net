#!/bin/bash
for modelfile in /modelfiles/*; do 
    echo -n "Running: '"
    echo "ollama create \"$(basename $modelfile)\" -f \"$modelfile\"'"
    ollama create "$(basename $modelfile)" -f "$modelfile"
done