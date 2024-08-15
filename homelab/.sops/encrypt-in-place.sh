#!/bin/bash
# Takes one file path as input
# Outputs to a new file named `$1.enc`

# if [ "$#" -ne 1 ]; then
#     echo "Usage: $0 <file_path>"
#     exit 1
# fi

# Set age directory and default recipients
AGE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SOPS_AGE_RECIPIENTS="$(<$AGE_DIR/.age-author-pubkeys)"

# Get host to which input file belongs
FILE_PATH=$1
HOST_AGE_PUBKEY="$AGE_DIR/../$(realpath -m --relative-to=$AGE_DIR $FILE_PATH | cut -d'/' -f2)/.age-pubkey"

if [[ -f $HOST_AGE_PUBKEY ]]; then
    SOPS_AGE_RECIPIENTS="$SOPS_AGE_RECIPIENTS,$(<$HOST_AGE_PUBKEY)"
fi

FILE_EXT=${FILE_PATH##*.}
FILE_NAME=${FILE_PATH%%.*}
OUTPUT_FILE="$FILE_NAME.enc.$FILE_EXT"

sops --encrypt --age ${SOPS_AGE_RECIPIENTS} -i $FILE_PATH