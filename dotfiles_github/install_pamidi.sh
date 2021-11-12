#!/bin/bash
git clone https://github.com/Jafner/pamidi.git ~/Git/pamidi
cd ~/Git/pamidi/
chmod +x install_daemon_systemd.sh
./install_daemon_systemd.sh
