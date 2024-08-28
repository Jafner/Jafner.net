# sops Encryption/Decryption Workflow in Git

1. The user creates a file called `secrets.env` anywhere in the repository. This file is [dotenv-formatted](https://stackoverflow.com/questions/68267862/what-is-an-env-or-dotenv-file-exactly) as simple key-value pairs where the value is a secret to be passed into a Stack or container. We want to be able to read the "shape" of the file (the names of the keys), even when the file is encrypted. 
2. The [`.gitattributes`](.gitattributes) file assignes the following properties to files called `secrets.env`:
   1. `filter=sops` which tells the local git instance to run the "sops" filter configured in [`.git/config`](/.git/config). 
   2. `diff=sops` which tells the local git instance to run the "sops" diff command instead of the normal `git diff` when diffing `secrets.env` files. 
3. The [`.git/config`](/.git/config) is configured with the "sops" filter and diff blocks referenced above. 
   1. `filter.sops.smudge=` will run the thing after the `=` when checking out the repository. This should decrypt our secrets, making them "dirty" again. We call [`decrypt-filter.sh`](/.sops/decrypt-filter.sh) and pass `%f` as a positional argument, which renders to the path of the file being filtered, relative to the repo root (e.g. `homelab/stacks/books/secrets.env`). 
   2. `filter.sops.clean=` will run the thing after the `=` when staging changes to commit. This should encrypt our secrets, making them "clean". We call [`encrypt-filter.sh`](/.sops/decrypt-filter.sh) and pass `%f` as a positional argument, which renders to the path of the file being filtered, relative to the repo root (e.g. `homelab/stacks/books/secrets.env`). 
   3. `filter.sops.required=true` will ensure that if the scripts fail, the commit will error out.
   4. `diff.sops.textconv=` will use the command after the `=` instead of `git diff` when comparing files. This affects whether files are considered "modified". 
4. When the user stages a new `secrets.env` file at `homelab/stacks/books/secrets.env`, we automatically run `encrypt.sh homelab/stacks/books/secrets.env`. This implictly passes the contents of `secrets.env` to the script at `/dev/stdin`. The script takes the following steps to generate the encrypted content of the file:
   1. Assert privatekey existence at `~/.age/key`. 
   2. Determine file extension. For now, we're only working with dotenv-formatted files, but sometimes we also need to support binary files. We use this information to set the `--input-type` parameter. 
   3. Encrypt the file contents. This command infers recipients from [`.sops.yaml`](/.sops.yaml). The command uses the privatekey (at `~/.age/key`) of the local user to encrypt the secret. We use [Shamir's secret sharing](https://en.wikipedia.org/wiki/Shamir%27s_secret_sharing) with [sops key groups](https://github.com/getsops/sops?tab=readme-ov-file#215key-groups) to require *at least two of*: author key, CI/CD key, and deploy key. Of course, the original privatekey can always decrypt the secret.
5. Our new `secrets.env` file is committed to the repository. Encrypted and json-formatted ([why not dotenv-formatted?](https://github.com/getsops/sops/issues/857#issuecomment-2307658865)). 
6. Now we want to deploy our new `homelab/stacks/books` Stack. We'll focus on the sops-related aspects of this process. 
   1. Our CI/CD environment is configured with an age keypair. Additional CI/CD environments will each be configured with their own keypairs.
   2. Our deploy environments (hosts) are each configured with an age keypair. 
   3. Our [CI/CD script](/.gitea/workflows/homelab_deploy-compose-stack.yml) is configured to decrypt secrets and export the variables before bringing up the Stack. 