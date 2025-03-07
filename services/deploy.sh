#!/bin/bash
# run me with 
# curl https://gitea.jafner.tools/Jafner/Jafner.net/raw/branch/main/homelab/stacks/deploy.sh | bash -s <stack to pass>

STACK=$1
mkdir -p /tmp/stack/$STACK $HOME/stacks/$STACK
git clone -n --depth=1 --filter=tree:0 https://gitea.jafner.tools/Jafner/Jafner.net.git /tmp/stack/$STACK && cd /tmp/stack/$STACK
git sparse-checkout set --no-cone homelab/stacks/$STACK && git checkout
mv -f homelab/stacks/$STACK/* $HOME/stacks/$STACK/
mv -f homelab/stacks/$STACK/.* $HOME/stacks/$STACK/
cd $HOME/stacks/$STACK && rm -rf /tmp/stack/$STACK

if [[ -z $AGE_DEPLOY_KEY ]]; then 
    echo "Error: AGE_DEPLOY_KEY not set. Cannot decrypt secrets."
else
    echo -e "$(cat $HOME/.age/$HOSTNAME.host.key)\n$AGE_DEPLOY_KEY" > $HOME/.age/combined.key
    export SOPS_AGE_KEY_FILE="$HOME/.age/combined.key"
    for file in $(find . -type f); do
        sops decrypt -i --input-type json "$file" 2>/dev/null && echo "Decrypted $file"
    done
fi

docker compose -f $HOME/stacks/$STACK/docker-compose.yml pull