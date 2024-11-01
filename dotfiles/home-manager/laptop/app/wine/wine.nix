{ inputs, ... }: {
  home.packages = [
    inputs.nix-ecuflash.packages."x86_64-linux".ecuflash
  ];
}