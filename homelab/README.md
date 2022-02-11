# homelab

Monolithic repository for my homelab

# Pulling Only Relevant Subdir
Per: https://stackoverflow.com/questions/4114887

```bash
~$ mkdir homelab && cd homelab/
git init
git config core.sparseCheckout true
git remote add -f origin ssh://git@gitlab.jafner.net:2229/Jafner/homelab.git
echo "<deployment name; e.g. server/>" > .git/info/sparse-checkout
git checkout main
```
