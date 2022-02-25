# homelab

Monolithic repository for my homelab

# Getting an SSH Key
1. `TMP=$(echo "$HOME/.ssh/$(echo $HOSTNAME)_id_rsa") && ssh-keygen -b 8192 -t rsa -C "$USER@$HOSTNAME" -f $TMP -N "" && echo "IdentityFile $TMP" > $HOME/.ssh/config && cat $(echo "$TMP").pub`
2. Go to Jafner -> Preferences -> SSH Keys.
3. Add the pubkey and save.



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
