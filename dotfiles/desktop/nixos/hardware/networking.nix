{ pkgs, lib, ... }: {
  networking = {
    hostName = "joey-desktop-nixos";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
  # Configure system packages
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}