{ pkgs, config, ... }:
let
  cfg = config.modules.programs.zed;
in
{
  options = with pkgs.lib; {
    modules.programs.zed = {
      enable = mkEnableOption "zed";
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
        nixd
        sops
      ];
      programs.zed-editor = {
        # https://mynixos.com/home-manager/options/programs.zed-editor
        enable = true;
        package = pkgs.zed-editor;
        extensions = [
          "Nix"
          "Catppuccin"
        ];
        userSettings = {
          tab_size = 2;
          languages."Nix" = {
            "language_servers" = [
              "!nil"
              "nixd"
            ];
          };
          theme = {
            mode = "system";
            dark = "Catppuccin Mocha";
            light = "Catppuccin Mocha";
          };
          terminal = {
            shell = {
              program = "zsh";
            };
          };
          lsp = {
            "nixd" = {
              nixpkgs.expr = "import (builtins.getFlake \"/home/joey/Git/Jafner.net\").inputs.nixpkgs { } ";
              formatting.command = "nixfmt";
              options = {
                nixos.expr = "(builtins.getFlake \"/home/joey/Git/Jafner.net\").nixosConfigurations.desktop.options";
              };
            };
          };
        };
      };
    };
  };
}
