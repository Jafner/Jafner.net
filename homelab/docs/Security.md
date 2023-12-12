# Security

## Host OS Initial Setup
For general-purpose hosts, we start from an up-to-date Debian base image. For appliances and application-specific hosts, we prefer downstream of Debian for consistency. 

### General Purpose Packages
Assuming a Debian base image, we install the following basic packages:

1. `curl` to facilitate web requests for debugging.
2. `nano` as preferred terminal text editor.
3. `inxi` to compile hardware info.
4. `git` to interact with homelab config repo.
5. `htop` to view primary host resources in real time.

### Installing Docker 
There are two modes of running Docker: root and rootless.
Docker was built to run as root, and running as root is much more convenient. However, any potential vulnerabilities in Docker risk privilege escalation. 

#### Installing Docker in Root mode (current, deprecated)
We use the convenient, insecure install script to install docker.
1. `curl -fsSL https://get.docker.com | sudo sh` to get and run the install script. 
2. `sudo systemctl enable docker` to enable the Docker daemon service.
3. `sudo usermod -aG docker $USER` to add the current user (should be "admin") to the docker group.
4. `logout` to log out as the current user. Log back in to apply new perms.
5. `docker ps` should now return an empty table.

https://docs.docker.com/engine/install/debian/

#### Installing Docker in Rootless mode (preferred)
This is the preferred process, as rootless mode mitigates many potential vulnerabilities in the Docker application and daemon. 

1. `sudo apt-get update && sudo apt-get install uidmap dbus-user-session fuse-overlayfs slirp4netns` to install the prerequisite packages to enable rootless mode.
2. Set up the Docker repository:

```sh
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

3. Install the Docker packages:

```sh
sudo apt-get install \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  docker-ce-rootless-extras
```

4. Run the rootless setup script with `dockerd-rootless-setuptool.sh install`
5. `systemctl --user start docker` to start the rootless docker daemon.
6. `systemctl --user enable docker && sudo loginctl enable-linger $(whoami)` to configure the rootless docker daemon to run at startup.
7. `export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock && docker context use rootless` to configure the client to connect to the socket.

Theoretically, this should work according to the Docker docs. But when I attempted to follow these steps I got the following error when attempting to create a basic nginx container:

```
docker: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: unable to apply cgroup configuration: unable to start unit "docker-1c7f642e0716cf1a67c6a0c6ad4a1de3833eb82682ce62b219f423fa1014e227.scope" (properties [{Name:Description Value:"libcontainer container 1c7f642e0716cf1a67c6a0c6ad4a1de3833eb82682ce62b219f423fa1014e227"} {Name:Slice Value:"user.slice"} {Name:Delegate Value:true} {Name:PIDs Value:@au [39360]} {Name:MemoryAccounting Value:true} {Name:CPUAccounting Value:true} {Name:IOAccounting Value:true} {Name:TasksAccounting Value:true} {Name:DefaultDependencies Value:false}]): Permission denied: unknown.
```

https://docs.docker.com/engine/security/rootless/

## Linux User Management
We create a non-root user (usually called "admin") with a strong password and passwordless sudo. 

On Debian-based systems, we take the following steps:

1. As root user, run `adduser admin` to create the non-root user called "admin".
2. As root user, run `usermod -aG sudo admin` to add the new "admin" user to the sudo group. 
3. As root user, run `visudo` and append this line to the end of the file: `admin ALL=(ALL) NOPASSWD:ALL`. 
4. Switch to the new user with `sudo su admin`.
5. As the new "admin" user, run `passwd` to create a new, strong password. Generate this password with the password manager and store it under the SSH Hosts folder. 

https://www.cyberciti.biz/faq/add-new-user-account-with-admin-access-on-linux/
https://www.cyberciti.biz/faq/linux-unix-running-sudo-command-without-a-password/
https://www.cyberciti.biz/faq/linux-set-change-password-how-to/


## Securing SSH

For all hosts we want to take the standard steps to secure SSH access. 

1. `mkdir /home/$USER/.ssh` to create the `~/.ssh` directory for the non-root user (usually "admin").
2. Copy your SSH public key to the clipboard, then `echo "<insert pubkey here>" >> /home/admin/.ssh/authorized_keys` to enable key-based SSH access to the user.
3. Install the authenticator libpam plugin package with `sudo apt install libpam-google-authenticator`
4. Run the authenticator setup with `google-authenticator` and use the following responses:
    - Do you want authentication tokens to be time-based? `y`
    - Do you want me to update your "/home/$USER/.google_authenticator" file? `y`
    - Do you want to disallow multiple uses of the same authentication token? `y`
    - Do you want to do so? `n` (refers to increasing time skew window)
    - Do you want to enable rate-limiting? `y` We enter our TOTP secret key into our second authentication method and save our one-time backup recovery codes.
5. Edit the `/etc/pam.d/sshd` file as sudo, and add this line to the top of the file `auth sufficient pam_google_authenticator.so nullok`.
6. Edit the `/etc/ssh/sshd_config` file as sudo, and ensure the following assertions exist:
    - `PubkeyAuthentication yes` to enable authentication via pubkeys in `~/.ssh/authorized_keys`.
    - `AuthenticationMethods publickey,keyboard-interactive` to allow both pubkey and the interactive 2FA prompt.
    - `PasswordAuthentication no` to disable password-based authentication.
    - `ChallengeResponseAuthentication yes` to enable 2FA interactive challenge.
    - `UsePAM yes` to use the 2FA authenticator libpam module.
7. Restart the SSH daemon with `sudo systemctl restart sshd.service`.

Note: SSH root login will be disabled implicitly by requiring pubkey authentication and having no pubkeys listed in `/root/.ssh/authorized_keys`.

https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-16-04

### SSH Key Management
The process for managing SSH keys should work as follows:

1. SSH access to hosts should be controlled via keys listed in `~/.ssh/authorized_keys`.
2. One key should map to one user on one device. 
3. When authorizing a key, review existing authorized keys and remove as appropriate.
4. Device keys should be stored under the "SSH Keys" folder in the password manager. The pubkey should be the "password" for easy copying, and the private component should be added as an attachment. 

## Patching and Updating
In the interest of proactively mitigating security risks, we try to keep packages up to date. We have two main concerns for patching: host packages, and docker images. Each of these have their own concerns and are handled separately.

### Host Packages via Unattended Upgrades
Since Debiant 9, the `unattended-upgrades` and `apt-listchanges` are installed by default. 

1. Install the packages with `sudo apt-get install unattended-upgrades apt-listchanges`.
2. Create the default automatic upgrade config with `sudo dpkg-reconfigure -plow unattended-upgrades`

By default, we will get automatic upgrades for the distro version default and security channels (e.g. `bullseye` and `bullseye-security`) with the `Debian` and `Debian-Security` labels.

https://wiki.debian.org/UnattendedUpgrades

### Debian Version Upgrade 
When the time comes for a major version upgrade on a Debian system, we take the following steps as soon as realistic.

1. Update the current system with `sudo apt-get update && sudo apt-get upgrade && sudo apt-get full-upgrade`.
2. Switch the update channel for APT sources.
    2a. Export the name of the new version codename to a variable with `NEW_VERSION_CODENAME=bookworm` (bookworm as an example).
    2b. `for file in /etc/apt/sources.list /etc/apt/sources.list.d/*; do sudo sed "s/$VERSION_CODENAME/$NEW_VERSION_CODENAME/g" $file; done`. 
3. Clean out old packages and pull the new lists `sudo apt-get clean && sudo apt-get update`
4. Update to most recent versions of all packages for new channel with `sudo apt-get upgrade && sudo apt-get full-upgrade`
5. Clean out unnecessary packages with `sudo apt-get autoremove`.
6. Reboot the host to finalize changes with `sudo shutdown -r now`.

Note: If migrating from Debian versions <12 to versions >=12, add the following repos (in addition to `main`) after step 2a: `contrib non-free non-free-firmware`.

https://wiki.debian.org/DebianUpgrade

### Docker Images
As of now, we have no automated process or tooling for updating Docker images. 

We usually update Docker images one stack at a time. For example, we'll update `calibre-web` on `fighter`:

1. Navigate to the directory of the stack. `cd ~/homelab/fighter/config/calibre-web`
2. Check the images and tags to be pulled with `docker-compose config | grep image`
3. Pull the latest version of the image tagged in the compose file `docker-compose pull`
4. Restart the containers to use the new images with `docker-compose up -d --force-recreate`

Note: We can update one image from a stack by specifying the name of the service. E.g. `docker-compose pull forwardauth`