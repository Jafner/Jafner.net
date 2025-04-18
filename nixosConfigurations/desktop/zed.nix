{ pkgs, username, ... }:
{
  home-manager.users."${username}" = {
    home.packages = with pkgs; [
      nixd
      sops
    ];
    programs.zed-editor = {
      # https://mynixos.com/home-manager/options/programs.zed-editor
      enable = true;
      package = pkgs.zed-editor; # Temp: https://github.com/NixOS/nixpkgs/pull/392319
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
}
