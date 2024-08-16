#!/bin/bash
# Takes file path as $1
# Takes file contents from stdin
# Outputs to stdout

# Set up directory variables and default age recipients
AGE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SOPS_AGE_RECIPIENTS="$(<$AGE_DIR/.age-author-pubkeys)"
HOST_AGE_PUBKEY_PATH="$(echo $1 | cut -d'/' -f 3)/.age-pubkey"
if [[ -f "$HOST_AGE_PUBKEY_PATH" ]]; then
    SOPS_AGE_RECIPIENTS="$SOPS_AGE_RECIPIENTS,$(<$HOST_AGE_PUBKEY_PATH)"
fi

if [[ -f $HOME/.age/key ]]; then
    export SOPS_AGE_KEY_FILE=$HOME/.age/key
else
    echo "SOPS_AGE_KEY_FILE not found at $HOME/.age/key"
    echo "Cannot encrypt secrets."
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
    sops --encrypt --age ${SOPS_AGE_RECIPIENTS} /dev/stdin
else
    sops --encrypt --input-type $FILE_TYPE --output-type $FILE_TYPE --age ${SOPS_AGE_RECIPIENTS} /dev/stdin
fi

