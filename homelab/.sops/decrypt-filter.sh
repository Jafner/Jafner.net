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
    cd $REPO_ROOT
    FILE_PATH=$(realpath "${REPO_ROOT}/$1") 
    echo "FILE_PATH: $FILE_PATH"
} > ~/decrypt-filter.stdout.log 2> ~/decrypt-filter.stderr.log

{ 
    sops --decrypt $FILE_PATH 
} 2>> ~/decrypt-filter.stderr.log
