# Stacks: Atomic Services using Docker Compose


### Get a Stack (from source with Git)
```sh
STACK=ai
mkdir -p $HOME/stacks/$STACK
git clone -n --depth=1 --filter=tree:0 https://gitea.jafner.tools/Jafner/Jafner.net.git /tmp/repo
cd /tmp/repo
git sparse-checkout set --no-cone homelab/stacks/$STACK
git checkout
mv homelab/stacks/$STACK $HOME/stacks/
cd $HOME/stacks/$STACK
rm -rf /tmp/repo
```

This will clone the stack from the repo into a tmp directory, extract the stack to `~/stacks/$STACK`, and then delete the temp clone. 

- This *does not* decrypt secrets.
- This *does not* bring up the stack.
- This *does* require Git.

