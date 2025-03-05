{ ... }: {
  imports = let stacksPath = ../../../homelab/stacks; in [
    "${stacksPath}/gitea-runner/stack.nix"
  ];
}