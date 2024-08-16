#!/bin/bash
# Takes file path from stdin
# Outputs to stdout
rm -f ~/decrypt-filter.stdout.log ~/decrypt-filter.stderr.log

{
    echo "pwd: $(pwd)"
} >> ~/decrypt-filter.stdout.log 2>> ~/decrypt-filter.stderr.log

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
    cd $REPO_ROOT
    FILE_PATH=$(realpath "${REPO_ROOT}/$1") 
    echo "FILE_PATH: $FILE_PATH"
} >> ~/decrypt-filter.stdout.log 2>> ~/decrypt-filter.stderr.log

{ 
    exec 3<<< "$(cat $1)"
    sops --decrypt /dev/fd/3
} 2>> ~/decrypt-filter.stderr.log
