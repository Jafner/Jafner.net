# Configure a New Host

## Prerequisites
- Fresh Debian 11+ installation on x86 hardware.
- SSH access to host.

## Create Admin User

1. Get su perms. Either via `sudo`, `su -`, or by logging in as the root user.
2. `adduser admin` to create the non-root admin user.
3. `usermod -aG sudo admin` to add the new user to the sudo group.
4. `sudo visudo` and append this line to the end of the file: `admin ALL=(ALL) NOPASSWD:ALL` to enable passwordless sudo. 

After these, you can `sudo su admin` to log into the new user account.

https://www.cyberciti.biz/faq/add-new-user-account-with-admin-access-on-linux/  
https://www.cyberciti.biz/faq/linux-unix-running-sudo-command-without-a-password/


## Set the Hostname
1. `sudo hostnamectl set-hostname <hostname>` to set the hostname.
2. `sudo nano /etc/hosts` and edit the old value for `127.0.1.1` to use the new hostname.

## Configure Secure SSH

1. `mkdir -p /home/admin/.ssh && echo "<insert pubkey here>" >> /home/admin/.ssh/authorized_keys` Add pubkey to authorized_keys. Make sure to place the correct SSH pubkey in the command before copying.
2. `sudo apt install libpam-google-authenticator` to install the Google 2FA PAM.
3. `google-authenticator` to configure the 2FA module. Use the following responses when prompted:

* Do you want authentication tokens to be time-based? `y`
* Do you want me to update your "/home/$USER/.google_authenticator" file? `y`
* Do you want to disallow multiple uses of the same authentication token? `y`
* Do you want to do so? `n` (refers to increasing time skew window)
* Do you want to enable rate-limiting? `y` We enter our TOTP secret key into our second authentication method and save our one-time backup recovery codes.

4. `sudo nano /etc/pam.d/sshd` to edit the PAM configuration, and add this line to the top of the file `auth sufficient pam_google_authenticator.so nullok`

5a. `sudo nano /etc/ssh/sshd_config` to open the SSH daemon config for editing. Make sure the following assertions exist:  

* `PubkeyAuthentication yes`
* `AuthenticationMethods publickey,keyboard-interactive`
* `PasswordAuthentication no`
* `ChallengeResponseAuthentication yes`
* `UsePAM yes`

5b. `echo $'PubkeyAuthentication yes\nAuthenticationMethods publickey,keyboard-interactive\nPasswordAuthentication no\nChallengeResponseAuthentication yes\nUsePAM yes' | sudo tee /etc/ssh/sshd_config.d/ssh.conf` to perform the above as a one-liner. Requires a version of OpenSSH/Linux that supports sourcing sshd config from the `/etc/ssh/sshd_config.d/*.conf` path.

6. `sudo systemctl restart sshd.service` to restart the SSH daemon.

## Install Basic Packages

1. `sudo apt install curl nano inxi git htop`

### Install Docker
1. `curl -fsSL https://get.docker.com | sudo sh` This is the most convenient and least safe way to do this. If this script is ever compromised, we'd be fucked.
2. `sudo systemctl enable docker` to enable the Docker service.
3. `sudo usermod -aG docker $USER` to add the current user (should be non-root admin) to docker group.
4. `logout` to relog and apply the new permissions.

## Clone the Homelab Repo

1. Create a new Gitlab personal access token for the device at [Personal Access Tokens](https://gitlab.jafner.net/-/profile/personal_access_tokens). Should be named like `warlock` and have the following scopes: `read_api`, `read_user`, `read_repository`. 
2. `mkdir ~/homelab ~/data && cd ~/homelab/ && git init && git config core.sparseCheckout true && git config pull.ff only` to init the repository with sparse checkout enabled. 
3. `git remote add -f origin https://<pat-name>:<pat-value>@gitlab.jafner.net/Jafner/homelab.git` to add the repo with authentication via read-only personal access token. NOTE: Make sure to replace `<pat-name>` with the name of the personal access token, and replace `<pat-value>` with the key for the personal access token.
4. `echo "$HOSTNAME/" > .git/info/sparse-checkout` to configure sparse checkout for the host.
5. `git checkout main` to switch to the main branch with the latest files.


