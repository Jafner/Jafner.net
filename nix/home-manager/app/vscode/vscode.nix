{ pkgs, ... }:
{
  ## Nix LSP
  home.packages = with pkgs; [ nixd ];
  ## VSCodium
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      continue.continue
    ];
    userSettings = {
      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
      "explorer.confirmDragAndDrop" = false;
    };
  };
}