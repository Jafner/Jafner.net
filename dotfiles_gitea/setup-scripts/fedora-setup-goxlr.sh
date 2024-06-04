#!/bin/bash

wget -o /tmp/goxlr.rpm $(curl -s https://api.github.com/repos/GoXLR-on-Linux/goxlr-utility/releases/latest | grep "browser_download_url.*rpm" | cut -d : -f 2,3 | tr -d \" | head -n 1)
sudo dnf install /tmp/goxlr.rpm
rm /tmp/goxlr.rpm

# Delete default profiles, replace with symlinked custom profiles
rm -rf ~/.local/share/goxlr-utility/profiles 
ln -s $(realpath ../config/goxlr) $(realpath ~/.local/share/goxlr-utility/profiles)

/usr/bin/goxlr-launcher
