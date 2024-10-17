{ pkgs, ... }:
{
  home.packages = with pkgs; [
    terraform
    sops ssh-to-age age
    doctl
  ];
}