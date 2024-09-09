{ config, pkgs, ... }:

{
  home.username = "joey";
  home.homeDirectory = "/home/joey";
  home.stateVersion = "24.05";
  home.packages = [];
  home.file = {};
  home.sessionVariables = {};
  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.bash.shellAliases = {
    hello = "echo hello world";
  };
}
