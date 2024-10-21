#!/bin/bash
# symlinks manifest:
# dotfiles/vscodium/
#   user.settings.json => ~/.config/VSCodium/User/settings.json
#   continue.config.json => ~/.continue/config.json

wget -O /tmp/codium.rpm $(curl -s https://api.github.com/repos/VSCodium/vscodium/releases/latest | grep "browser_download_url.*.x86_64.rpm" | cut -d : -f 2,3 | tr -d \" | head -n 1)
sudo dnf install /tmp/codium.rpm
rm /tmp/codium.rpm

ln $(realpath ../config/vscodium/user.settings.json) $(realpath ~/.config/VSCodium/User/settings.json)
ln $(realpath ../config/vscodium/continue.config.json) $(realpath ~/.continue/config.json)