{ ... }: {
  imports = [
    ./hardware.nix
    ./network-shares.nix
    ./stacks.nix
    ./terminal-environment.nix
  ];

  systemd.enableEmergencyMode = false;
}