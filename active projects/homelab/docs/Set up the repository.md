# Setting Up the Repository
1. Create a new Gitlab [Personal Access Token](https://gitlab.jafner.net/-/profile/personal_access_tokens) named after the host on which it will be used. It should have the scopes `read_api`, `read_user`, `read_repository`, and, optionally, `write_repository` if the host will be pushing commits back to the origin. Development hosts should have the `write_repository` permission. Note the *token name* and *token key* for step 6.
2. `mkdir ~/homelab ~/data && cd ~/homelab` Create the `~/homelab` and `~/data` directories. This should be under the `admin` user's home directory, or equivalent. *It should not be owned by root.*
3. `git init` Initialize the git repo. It should be empty at this point. We must init the repo empty in order to configure sparse checkout. 
4. `git config core.sparseCheckout true && git config core.fileMode false && git config pull.ff only && git config init.defaultBranch main` Configure the repo to use sparse checkout and ignore file mode changes. Also configure default branch and pull behavior. 
5. (Optional) `echo "$HOSTNAME/" > .git/info/sparse-checkout` Configure the repo to checkout only the files relevant to the host (e.g. fighter). Development hosts should not use this. 
6. `git remote add -f origin https://<token name>:<token key>@gitlab.jafner.net/Jafner/homelab.git` Add the origin with authentication via personal access token and fetch. Remember to replace the placeholder token name and token key with the values from step 1.
7. `git checkout main` Checkout the main branch to fetch the latest files. 

## Disabling Sparse Checkout
To disable sparse checkout, simply run `git sparse-checkout disable`. 
With this, it can also be re-eneabled with `git sparse-checkout init`.
You can use these two commands to toggle sparse checkout.
Per: https://stackoverflow.com/questions/36190800/how-to-disable-sparse-checkout-after-enabled