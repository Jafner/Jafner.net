#!/bin/bash
# Takes file path from stdin
# Outputs to stdout

# Set age key file path
# If no private key exists at the expected location,
#   Create the key file at the expected location
SOPS_AGE_KEY_FILE=$HOME/.age/key
if [[ -f $SOPS_AGE_KEY_FILE ]]; then
    export SOPS_AGE_KEY_FILE=$HOME/.age/key
    age-keygen -o $SOPS_AGE_KEY_FILE
fi

# Set age directory and default recipients
AGE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SOPS_AGE_RECIPIENTS="$(<$AGE_DIR/.age-author-pubkeys)"

# Get host to which input file belongs
FILE_PATH=$1
HOST_AGE_PUBKEY="$AGE_DIR/../$(realpath -m --relative-to=$AGE_DIR $FILE_PATH | cut -d'/' -f2)/.age-pubkey"

if [[ -f $HOST_AGE_PUBKEY ]]; then
    SOPS_AGE_RECIPIENTS="$SOPS_AGE_RECIPIENTS,$(<$HOST_AGE_PUBKEY)"
fi

input_file=$1
file_extension=${input_file##*.}
file_name=${input_file%%.*}
output_file="$file_name.enc.$file_extension"

sops --decrypt --age ${SOPS_AGE_RECIPIENTS} -i $input_file 
