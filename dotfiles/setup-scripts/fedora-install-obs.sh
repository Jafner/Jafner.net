#!/bin/bash

flatpak install flathub com.obsproject.Studio

rm -rf ~/.config/obs-studio/basic
ln -s $(realpath ../config/obs-studio/basic) $(realpath ~/.config/obs-studio/basic)

rm -rf ~/.config/obs-studio/global.ini
ln -s $(realpath ../config/obs-studio/global.ini) $(realpath ~/.config/obs-studio/global.ini)
