# Stacks: Atomic Services using Docker Compose


### Build a Stack (from source with Git)
```sh
STACK=gitea-runner
mkdir -p $HOME/stacks/$STACK
git clone -n --depth=1 --filter=tree:0 https://gitea.jafner.tools/Jafner/Jafner.net.git /tmp/repo
cd /tmp/repo
git sparse-checkout set --no-cone homelab/stacks/$STACK
git checkout
zip -r $STACK.zip homelab/stacks/$STACK
rm -rf /tmp/repo
```

This will clone the stack from the repo into a tmp directory, extract the stack to `~/stacks/$STACK`, and then delete the temp clone. 

- This *does not* decrypt secrets.
- This *does not* bring up the stack.
- This *does* require Git.

### Pull a Stack (from source with Git)
```sh
STACK=books
mkdir -p /tmp/stack/$STACK
git clone -n --depth=1 --filter=tree:0 https://gitea.jafner.tools/Jafner/Jafner.net.git /tmp/stack/$STACK && cd /tmp/stack/$STACK
git sparse-checkout set --no-cone homelab/stacks/$STACK && git checkout
mv homelab/stacks/$STACK $HOME/stacks/ 
cd $HOME/stacks/$STACK && rm -rf /tmp/stack/$STACK

echo -e "$(cat $HOME/.age/$HOSTNAME.host.key)\n$AGE_DEPLOY_KEY" > $HOME/.age/combined.key
export SOPS_AGE_KEY_FILE="$HOME/.age/combined.key"
for file in $(find . -type f); do
    sops decrypt -i --input-type json "$file" 2>/dev/null && echo "Decrypted $file"
done
```

