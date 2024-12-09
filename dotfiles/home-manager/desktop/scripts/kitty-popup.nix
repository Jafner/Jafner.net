{ pkgs, ... }: { 
  home.packages = with pkgs; [
    ( writeShellApplication {  
      name = "kitty-popup"; 
      runtimeInputs = [
        kitty
      ];
      text = ''
        #!/bin/bash

        # A helper script to launch a kitty window for quick tasks.
        # A glorified alias.

        ${pkgs.kitty}/bin/kitty \
          --override initial_window_width=800 \
          --override initial_window_height=480 \
          --override remember_window_size=no \
          --class kitty-popup \
          "$@"
      '';
    } )
  ];
}
