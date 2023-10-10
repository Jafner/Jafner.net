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
            # contains volume mapping env vars, used automatically by
            # docker-compose to expand ${...}.
            README.md 
            # if a service stack has documentation specific to itself, 
            # it will be contained within this file. This usually contains 
            # procedure for interacting with a container and system configuration 
            # changes that could not be tracked in code (e.g. /etc/fstab or 
            # crontab or /etc/docker/daemon.json)
```

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

# Debian: Setting FQDN Hostname PS1
By default, Debian will print the domain part of its hostname (e.g. hostname `jafner.net` will print `jafner` in the terminal prompt). I like to separate my hosts by TLD (e.g. `jafner.net`, `jafner.chat`, `jafner.tools`, etc.), so printing the TLD in the hostname for the PS1 is useful. 

For a standard Debian 11 installation, the PS1 is set in this block of `~/.bashrc`:

```bash
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
```

We can achieve the desired behavior by replacing instances of `\h` with `\H` in both of these prompts (and elsewhere in the bashrc file if necessary). Note: Don't forget to `source ~/.bashrc` to apply the new configuration!

Reference: [Cyberciti.biz - How to Change / Set up bash custom prompt (PS1) in Linux](https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html)