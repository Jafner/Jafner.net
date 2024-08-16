#!/bin/bash
# Takes file path from stdin
# Outputs to stdout

if ! [[ -f $1 ]]; then
    echo "\$1 is not a file"
    echo "\$1: $1"
    exit 1
fi

# Set age key file path
# If no private key exists at the expected location,
#   Create the key file at the expected location
SOPS_AGE_KEY_FILE=$HOME/.age/key
if [[ ! -f $SOPS_AGE_KEY_FILE ]]; then
    age-keygen -o $SOPS_AGE_KEY_FILE
fi

export SOPS_AGE_KEY_FILE=$HOME/.age/key

# Set age directory and default recipients
AGE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SOPS_AGE_RECIPIENTS="$(<$AGE_DIR/.age-author-pubkeys)"
FILE_PATH=$(realpath $1)

# Check for host pubkey, add as recipient if present
if [[ -f "$AGE_DIR/../$(realpath -m --relative-to=$AGE_DIR $FILE_PATH | cut -d'/' -f2)/.age-pubkey" ]]; then
    HOST_AGE_PUBKEY=$AGE_DIR/../$(realpath -m --relative-to=$AGE_DIR $FILE_PATH | cut -d'/' -f2)/.age-pubkey
    HOST_AGE_PUBKEY=$(realpath $HOST_AGE_PUBKEY)
    SOPS_AGE_RECIPIENTS="$SOPS_AGE_RECIPIENTS,$(<$HOST_AGE_PUBKEY)"
fi

sops --decrypt --age ${SOPS_AGE_RECIPIENTS} $FILE_PATH 
