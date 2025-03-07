{ ... }: {
  imports = let stacksPath = ../../services; in [
    "${stacksPath}/gitea/stack.nix"
    "${stacksPath}/gitea-runner/stack.nix"
    "${stacksPath}/vaultwarden/stack.nix"
    "${stacksPath}/monitoring/stack.nix"
    "${stacksPath}/traefik/stack.nix"
  ];
}