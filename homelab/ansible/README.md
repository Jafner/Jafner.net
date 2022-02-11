# Ansible
This project contains inventory, var, and playbook files to administrate the homelab.

# Useful Ad-Hoc Commands

```bash
ansible all -m ping # ping all hosts
ansible all -a "free -h" # won't work on BSD
ansible all -m apt -a "name=inxi state=latest update_cache=true" --become # install inxi
ansible all -m shell -a "inxi -b" # run inxi

```

# Running on WSL
Running a proper ansible install on WSL requires updating to Debian 11.
1. Open Powershell as Administrator
2. Install Debian with `wsl.exe --install --distribution Debian`
3. Launch the instance with `wsl.exe -d Debian`
4. Change the apt repositories with `sudo nano /etc/apt/sources.list` and update it to look like this:
    ```
    deb http://deb.debian.org/debian bullseye main contrib non-free
    deb http://deb.debian.org/debian bullseye-updates main contrib non-free
    deb http://security.debian.org/debian-security bullseye-security main contrib non-free
    ```
5. Clean and update the cache with `sudo apt clean && sudo apt update`
6. Upgrade all packages with `sudo apt full-upgrade`
7. Remove dangling packages with `sudo apt autoremove`
8. Log out with `exit`, shutdown wsl with `wsl.exe --shutdown`, then start it back up with `wsl.exe -d Debian`.
9. Make sure everything worked with `cat /etc/os-release`