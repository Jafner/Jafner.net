AGE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Set up age keypair
if [[ -f $HOME/.age/key ]]; then 
    if ! cat ~/.bashrc | grep -q "export SOPS_AGE_KEY_FILE"; then
        echo "Add this line to your shell profile (e.g. ~/.bashrc or ~/.zshrc):"
        echo "export SOPS_AGE_KEY_FILE=$HOME/.age/key"
    else
        echo "SOPS_AGE_KEY_FILE: $SOPS_AGE_KEY_FILE"
    fi
else
    mkdir -p $HOME/.age
    HOST_CONFIG_DIR=$AGE_DIR/../$HOSTNAME/
    mkdir -p $HOST_CONFIG_DIR
    age-keygen -o $HOME/.age/key > $HOST_CONFIG_DIR/.age-pubkey
    echo "Pubkey added to $HOST_CONFIG_DIR/.age-pubkey"
    echo "If any secrets have already been committed for this host, re-encrypt them with the new pubkey as a recipient."
fi

# Configure the git filters
git config --local filter.sops.smudge $AGE_DIR/decrypt-filter.sh
git config --local filter.sops.clean $AGE_DIR/encrypt-filter.sh
git config --local filter.sops.required true
