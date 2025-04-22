{ ... }:
{
  imports = [
    ./traefik.nix
    ./ai.nix
    ./autopirate.nix
    ./keycloak.nix
    ./minecraft.nix
  ];
}
