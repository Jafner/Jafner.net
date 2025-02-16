{ ... }: {
  imports = let stacksPath = ../../../homelab/stacks; in [
    "${stacksPath}/gitea/stack.nix"
    "${stacksPath}/gitea-runner/stack.nix"
    "${stacksPath}/keycloak/stack.nix"
    "${stacksPath}/monitoring/stack.nix"
    "${stacksPath}/traefik/stack.nix"
    "${stacksPath}/wireguard/stack.nix"
  ];
}