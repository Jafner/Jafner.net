{ ... }: {
  imports = [
    ./ai/stack.nix
    ./autopirate/stack.nix
    ./books/stack.nix
    ./coder/stack.nix
    ./gitea/stack.nix
    ./gitea-runner/stack.nix
    ./keycloak/stack.nix
    ./minecraft/stack.nix
    ./traefik/stack.nix
    ./uptimekuma/stack.nix
  ];
}
