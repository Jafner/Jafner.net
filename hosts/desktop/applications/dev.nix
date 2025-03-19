{ pkgs, pkgs-unstable, sys, ... }: {
  home-manager.users."${sys.username}" = {
    home.packages = with pkgs; [ nixd sops ];
    programs.zed-editor = {
      # https://mynixos.com/home-manager/options/programs.zed-editor
      enable = true;
      package = pkgs-unstable.zed-editor;
      extensions = [ "Nix" "Catppuccin" ];
      userSettings = {
        languages."Nix"."language_servers" = [ "!nil" "nixd" ];
        theme = {
          mode = "system";
          dark = "Catppuccin Mocha";
          light = "Catppuccin Mocha";
        };
        terminal = {
          # using bash as a workaround.
          # zsh in the integrated terminal misbehaves.
          # seems to render multiple characters with every keystroke (incl. backspace)
          shell = { program = "bash"; };
        };
      };
    };
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        adzero.vscode-sievehighlight
      ];
      userSettings = {
        "editor.fontFamily" = pkgs.lib.mkDefault "'DejaVu Sans Mono'"; # Potentially collides with Stylix
        "nix.serverPath" = "nixd";
        "nix.enableLanguageServer" = true;
        "explorer.confirmDragAndDrop" = false;
        "explorer.confirmDelete" = false;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "security.workspace.trust.untrustedFiles" = "open";
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "terminal.integrated.fontFamily" = pkgs.lib.mkDefault "'DejaVu Sans Mono'"; # Potentially collides with Stylix
        "terminal.integrated.profiles.linux.zsh.path" = "/usr/bin/zsh";
        "diffEditor.maxComputationTime" = 0;
      };
    };
  };
}
