#!/bin/bash
# Takes one file path as input
# Outputs to a new file with `.enc` stripped from the end

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

SOPS_AGE_KEY_FILE=$HOME/.age/key
if [[ -f $SOPS_AGE_KEY_FILE ]]; then
    export SOPS_AGE_KEY_FILE=$HOME/.age/key
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

sops --decrypt --age ${SOPS_AGE_RECIPIENTS} $input_file 
