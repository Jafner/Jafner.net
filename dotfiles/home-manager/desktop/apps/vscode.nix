{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      adzero.vscode-sievehighlight
    ];
    userSettings = {
      "editor.fontFamily" = "'DejaVu Sans Mono'";
      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "security.workspace.trust.untrustedFiles" = "open";
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.profiles.linux.zsh.path" = "/usr/bin/zsh";
    };
  };
}
