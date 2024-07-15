#!/bin/bash
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config 
cp .ssh/* ~/.ssh/
sudo systemctl enable sshd.service
sudo systemctl start sshd.service
