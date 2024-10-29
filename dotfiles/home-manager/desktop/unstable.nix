{ pkgs-unstable, inputs, ... }:
{
  home.packages = [
    pkgs-unstable.librespot
    pkgs-unstable.fzf
    inputs.deploy-rs.defaultPackage.x86_64-linux
  ];
}