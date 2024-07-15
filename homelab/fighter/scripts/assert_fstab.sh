#!/bin/bash

cat ~/homelab/fighter/fstab.txt | sudo tee > /etc/fstab
sudo systemctl daemon-reload
