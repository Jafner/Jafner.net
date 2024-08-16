#!/bin/bash
# Takes file path from stdin
# Outputs to stdout

# Set up directory variables and default age recipients
{
    AGE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
    REPO_ROOT=$(realpath "$AGE_DIR/../../")
    cd $REPO_ROOT
    SOPS_AGE_RECIPIENTS="$(<$AGE_DIR/.age-author-pubkeys)"
    FILE_PATH=$(realpath "${REPO_ROOT}/$1") 
} >> ~/encrypt-filter.stdout.log 2>> ~/encrypt-filter.stderr.log

# Check for host pubkey, add as recipient if present
if [[ -f "$AGE_DIR/../$(realpath -m --relative-to=$AGE_DIR $FILE_PATH | cut -d'/' -f2)/.age-pubkey" ]]; then
    HOST_AGE_PUBKEY=$AGE_DIR/../$(realpath -m --relative-to=$AGE_DIR $FILE_PATH | cut -d'/' -f2)/.age-pubkey
    HOST_AGE_PUBKEY=$(realpath $HOST_AGE_PUBKEY)
    SOPS_AGE_RECIPIENTS="$SOPS_AGE_RECIPIENTS,$(<$HOST_AGE_PUBKEY)"
fi

sops --encrypt --age ${SOPS_AGE_RECIPIENTS} $FILE_PATH