#!/bin/bash
# Takes file path as $1
# Takes file contents from stdin
# Outputs to stdout

if [[ -f $HOME/.age/key ]]; then
    export SOPS_AGE_KEY_FILE=$HOME/.age/key
else
    echo "SOPS_AGE_KEY_FILE not found at $HOME/.age/key"
    echo "Cannot encrypt secrets."
    exit 1
fi

# Set input/output type
FILE_EXT="${1##*.}"

case $FILE_EXT in
    "env")
        FILE_TYPE=dotenv ;;
    "json")
        FILE_TYPE=json ;;
    "yaml")
        FILE_TYPE=yaml ;;
    "ini")
        FILE_TYPE=ini ;;
esac

if [[ -z ${FILE_TYPE+x} ]]; then
    sops --encrypt --config ../.sops.yaml /dev/stdin
else
    sops --encrypt --config ../.sops.yaml --input-type $FILE_TYPE --output-type json /dev/stdin
fi