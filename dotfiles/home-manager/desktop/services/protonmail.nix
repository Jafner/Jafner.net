{ pkgs, ... }: {
  home.packages = with pkgs; [
    protonup-ng
    protonmail-bridge-gui
  ];
}