{ pkgs, config, ... }:
let
  cfg = config.modules.programs.kitty;
in
{
  options = with pkgs.lib; {
    modules.programs.kitty = {
      enable = mkEnableOption "kitty";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    home-manager.users."${cfg.username}" = {
      home.packages = with pkgs; [
        (writeShellApplication {
          name = "kitty-popup";
          runtimeInputs = [ ];
          text = ''
            #!/bin/bash

            ${pkgs.kitty}/bin/kitty \
              --override initial_window_width=1280 \
              --override initial_window_height=720 \
              --override remember_window_size=no \
              --class kitty-popup \
              "$@"
          '';
        })
      ];
      programs.kitty.enable = true;
    };
  };
}
