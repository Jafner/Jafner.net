#!/bin/bash

set -x
git clone https://github.com/Jafner/pamidi.git ~/Git/pamidi
cd ~/Git/pamidi/
sudo pacman -Sy xdotool
chmod +x install_daemon_systemd.sh
./install_daemon_systemd.sh
