{ sys, ... }: {
  imports = [
    ./server.nix
    ./docker.nix
    ./network-shares.nix
    ./stacks.nix
    ./terminal-environment.nix
  ];
  # DO NOT CHANGE
  system.stateVersion = "24.11";
  home-manager.users.${sys.username}.home.stateVersion = "24.11";
}