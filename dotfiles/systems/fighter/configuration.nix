{ ... }: {
  imports = [
    ./server.nix
    ./docker.nix
    ./network-shares.nix
    ./stacks.nix
    ./terminal-environment.nix
  ];
}