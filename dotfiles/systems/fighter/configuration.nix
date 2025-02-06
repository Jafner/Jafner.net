{ sys, ... }: {
  imports = [
    ./boot.nix
    ./docker.nix
    ./hardware.nix
    ./network-shares.nix
    ./networking.nix
    ./server.nix
    ./stacks.nix
    ./terminal-environment.nix

    ../../modules/sops.nix
  ];

  systemd.enableEmergencyMode = false;
  # DO NOT CHANGE
  system.stateVersion = "24.11";
  home-manager.users.${sys.username}.home.stateVersion = "24.11";
}