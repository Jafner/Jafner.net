#!/bin/bash

# Step 1: Install font
if ! [ -d "$HOME/.fonts" ]; then
    mkdir -p "$HOME/.fonts"
fi
fonts_list=
if ! [[ $(fc-list) =~ "JetBrainsMonoNerdFont" ]]; then
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz  | tar -xf -C "$HOME/.fonts"
    fc-cache
fi

# Step 2: Install zsh
if ! [ -x "$(command -v zsh)" ]; then
    sudo dnf install zsh
fi

# Set default shell to zsh
if [ -z "$SHELL" ] || [ "$(basename $SHELL)" != "zsh" ]; then
    chsh -s $(which zsh)
fi

# Step 3: Configure ~/.zshrc
if ! [ -f "$HOME/.zshrc" ]; then
    cp ../.zshrc $HOME/
fi

# Step: Init the configuration
source ~/.zshrc