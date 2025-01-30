{ ... }: {
  imports = let stacksPath = ../../../homelab/stacks; in [
    "${stacksPath}/traefik/stack.nix"
    "${stacksPath}/send/stack.nix"
  ];
}