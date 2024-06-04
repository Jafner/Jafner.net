#!/bin/bash

THEME_DIR=~/.local/share/sounds/__custom
mkdir -p $THEME_DIR && cd $THEME_DIR

touch $THEME_DIR/.disabled

cat << 'EOF' > $THEME_DIR/index.theme
[Sound Theme]
Name=__custom
Inherits=freedesktop
Directories=
EOF

gsettings set org.gnome.desktop.sound theme-name '__custom'


