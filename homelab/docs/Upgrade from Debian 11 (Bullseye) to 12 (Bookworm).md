1. Update existing packages. Run `sudo apt-get update && sudo apt-get upgrade` to fetch and install the latest versions of existing packages from the Debian 11 release channel. 
2. Reboot the system. Follow the appropriate shutdown procedure for the host. 
3. Edit the `sources.list` file to point to the new release channels. Run `sudo nano /etc/apt/sources.list`, then replace the release channel names for bullseye with those for bookworm. 
4. Update and upgrade packages minimally. Run `sudo apt update && sudo apt upgrade --without-new-pkgs`. 
5. Fully upgrade the system. Run `sudo apt full-upgrade`.
6. Validate the SSHD config file. Run `sudo sshd -t`. 

[CyberCiti.biz](https://www.cyberciti.biz/faq/update-upgrade-debian-11-to-debian-12-bookworm/)