AGE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Check for existing private key
if ! [[ -f ~/.age/key ]]; then 
    mkdir -p $HOME/.age
    age-keygen -o $HOME/.age/key > $AGE_DIR/../$HOSTNAME/.age-pubkey
    echo "Pubkey added to $AGE_DIR/.age-pubkeys"
    echo "Remember to add, commit, push, the new key, and then re-encrypt all secrets for the new pubkey list."
fi

# Configure private key path, and pubkey list env vars.
export SOPS_AGE_KEY_FILE=$HOME/.age/key
#echo 'export SOPS_AGE_RECIPIENTS=$(cat $AGE_DIR/.age-pubkeys)' >> $HOME/.bashrc
#echo 'export SOPS_AGE_KEY_FILE=$HOME/.age/key' >> $HOME/.bashrc

alias enc="$AGE_DIR/.age-encrypt.sh"
alias dec="$AGE_DIR/.age-decrypt.sh"

# Configure the git filters
# git config --local filter.sops.smudge $AGE_DIR/.age-decrypt.sh
# git config --local filter.sops.clean $AGE_DIR/.age-encrypt.sh
# git config --local filter.sops.required true
