#!/bin/bash

sudo dnf install kernel-devel
sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/hardware:/razer/Fedora_$(rpm -E %fedora)/hardware:razer.repo
sudo dnf install openrazer-meta

