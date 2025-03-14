{ pkgs, sys, ... }: {
  home-manager.users."${sys.username}" = { 
    home.packages = with pkgs; [
      kdePackages.konsole
      kitty
      ( pkgs.writeShellApplication {
        name = "kitty-popup";
        runtimeInputs = [];
        text = ''
          #!/bin/bash

          kitty \
            --override initial_window_width=1280 \
            --override initial_window_height=720 \
            --override remember_window_size=no \
            --class kitty-popup \
            "$@"
        '';
      } )
    ];
    programs.kitty = { enable = true; };
    programs.tmux = {
      enable = true;
      newSession = true;
      baseIndex = 1;
      disableConfirmationPrompt = true;
      mouse = true;
      prefix = "C-b";
      resizeAmount = 2;
      plugins = with pkgs; [
        { plugin = tmuxPlugins.resurrect; }
        { plugin = tmuxPlugins.tmux-fzf; }
      ];
      shell = "${pkgs.zsh.shellPath}";
    };
  };
}