#!/bin/bash
# Takes file path from stdin
# Outputs to stdout

# Set age key file path
# If no private key exists at the expected location,
#   Create the key file at the expected location
SOPS_AGE_KEY_FILE=$HOME/.age/key
if [[ ! -f $SOPS_AGE_KEY_FILE ]]; then
    age-keygen -o $SOPS_AGE_KEY_FILE
fi 
export SOPS_AGE_KEY_FILE=$HOME/.age/key

# Set up directory variables and default age recipients
{
    AGE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
    REPO_ROOT=$(realpath "$AGE_DIR/../../")
    SOPS_AGE_RECIPIENTS="$(<$AGE_DIR/.age-author-pubkeys)"
    FILE_PATH=$(realpath "${REPO_ROOT}/$1") 
    echo "FILE_PATH: $FILE_PATH"
} > ~/decrypt-filter.stdout.log 2> ~/decrypt-filter.stderr.log

# Check for host pubkey, add as recipient if present
{
    if [[ -f "$AGE_DIR/../$(realpath -m --relative-to=$AGE_DIR $FILE_PATH | cut -d'/' -f2)/.age-pubkey" ]]; then
        HOST_AGE_PUBKEY=$AGE_DIR/../$(realpath -m --relative-to=$AGE_DIR $FILE_PATH | cut -d'/' -f2)/.age-pubkey
        HOST_AGE_PUBKEY=$(realpath $HOST_AGE_PUBKEY)
        SOPS_AGE_RECIPIENTS="$SOPS_AGE_RECIPIENTS,$(<$HOST_AGE_PUBKEY)"
    fi
} >> ~/decrypt-filter.stdout.log 2>> ~/decrypt-filter.stderr.log

{ 
    sops --decrypt --age ${SOPS_AGE_RECIPIENTS} $FILE_PATH 
} 2>> ~/decrypt-filter.stderr.log
