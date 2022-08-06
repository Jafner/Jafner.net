# homelab

Monolithic repository for my homelab

# Navigation
This repo is (mostly) organized into the following structure:
```bash
/ 
# The root contains repository meta-information like .gitignore, 
# .gitlab-ci.yml, .gitmodules, and README.md. 
  docs/ 
  # The /docs directory is for all self-contained documentation 
  # that is not tied to a specific service. Service-specific documentation
  # is contained in /$host/config/$service/README.md
    img/ 
    # supporting images for use in docs

  $host/ 
  # There are separate directories for the details and configuration of
  # each host. At the root of `/$host/` we have non-authoritative 
  # documentation and reference. This includes printouts of hardware 
  # configs (`inxi -b`), host-specific procedure docs, useful scripts, etc.
    scripts/
    # if a host has scripts for automating recurring tasks, 
    # they will be placed here.
    config/ 
    # Anything in the `/$host/config` directory is used as a source of 
    # truth from which hosts pull and apply the defined configuration.
        $service/ 
        # for Docker-enabled hosts each service stack will be 
        # configured within a directory
            docker-compose.yml 
            # all services (except minecraft, which needed a 
            # more modular system) use docker-compose.yml to 
            # define their stack configuration. 
            .env 
            # contains environment variables to be used by multiple 
            # containers within a stack
            README.md 
            # if a service stack has documentation specific to itself, 
            # it will be contained within this file. This usually contains 
            # procedure for interacting with a container and system configuration 
            # changes that could not be tracked in code (e.g. /etc/fstab or 
            # crontab or /etc/docker/daemon.json)
```

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

## Disabling Sparse Checkout
To disable sparse checkout, simply run `git sparse-checkout disable`. 
With this, it can also be re-eneabled with `git sparse-checkout init`.
You can use these two commands to toggle sparse checkout.
Per: https://stackoverflow.com/questions/36190800/how-to-disable-sparse-checkout-after-enabled
