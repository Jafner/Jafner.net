{ ... }: {
  imports = [
    ../../modules/system.nix
    ../../modules/docker.nix
    ../../modules/sops.nix
    ./stacks.nix
    
  ];
}