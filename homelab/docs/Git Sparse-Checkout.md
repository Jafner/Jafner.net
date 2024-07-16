# Git Sparse-Checkout
We don't want every device that needs *any* part of the Jafner.net monorepo to get *all* of the monorepo. So we use [`git-sparse-checkout`](https://git-scm.com/docs/git-sparse-checkout) to pull only one or more subpaths when we clone.

Ensure that the device to be configured has an SSH pubkey with permission to pull/push to the repository.

```bash
mkdir ~/Jafner.net
cd ~/Jafner.net
git config --global init.defaultBranch main
git init
git config core.sparseCheckout true
git config core.fileMode false 
git config pull.ff only 
git config init.defaultBranch main
echo "homelab/$HOSTNAME/" >> .git/info/sparse-checkout
git remote add -f origin ssh://git@gitea.jafner.tools:2225/Jafner/Jafner.net.git
git pull
```