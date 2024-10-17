{ pkgs, lib, ... }:
{
  ## Nix LSP
  home.packages = with pkgs; [ nixd ];
  ## VSCodium
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      continue.continue
    ];
    userSettings = {
      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
      "explorer.confirmDragAndDrop" = false;
      "workbench.colorTheme" = "Stylix";
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "editor.fontFamily" = lib.mkForce "'Symbols Nerd Font Mono', 'PowerlineSymbols', 'DejaVu Sans Mono'";
      "git.enableSmartCommit" = true;
    };
    userTasks = {
      version = "2.0.0";
      tasks = [
        {
          type = "shell";
          label = "NixOS Rebuild Switch";
          command = "sudo nixos-rebuild switch --flake ~/Jafner.net/nix";
          problemMatcher =  [];
        }
        {
          type = "shell";
          label = "Home-Manager Switch";
          command = "home-manager switch -b bak --flake ~/Jafner.net/nix";
          problemMatcher =  [];
        }
        {
          label = "System Rebuild";
          dependsOn =  ["NixOS Rebuild Switch" "Home-Manager Switch" ];
          dependsOrder = "sequence";
          problemMatcher = [];
        }
      ];
    };
  };
}