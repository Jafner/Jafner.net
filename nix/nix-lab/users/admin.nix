{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jq
  ];
  programs.home-manager = {
    enable = true;
  };
  home.stateVersion = "24.05";
}