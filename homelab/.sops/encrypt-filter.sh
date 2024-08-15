#!/bin/bash
# Takes input on stdin
# Outputs to stdout

# Set age directory and default recipients
AGE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SOPS_AGE_RECIPIENTS="$(<$AGE_DIR/.age-author-pubkeys)"

# Get host to which input file belongs
FILE_PATH=$1
HOST_AGE_PUBKEY="$AGE_DIR/../$(realpath -m --relative-to=$AGE_DIR $FILE_PATH | cut -d'/' -f2)/.age-pubkey"

if [[ -f $HOST_AGE_PUBKEY ]]; then
    SOPS_AGE_RECIPIENTS="$SOPS_AGE_RECIPIENTS,$(<$HOST_AGE_PUBKEY)"
fi

sops --encrypt --age ${SOPS_AGE_RECIPIENTS} /dev/fd/3