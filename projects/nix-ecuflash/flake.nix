{
  description = "A Nix flake for EcuFlash";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    erosanix.url = "github:emmanuelrosa/erosanix";
  };
  outputs = { self, nixpkgs, erosanix }: {
    packages.x86_64-linux = let
      pkgs = import "${nixpkgs}" {
        system = "x86_64-linux";
      };
    in with (pkgs // erosanix.packages.x86_64-linux // erosanix.lib.x86_64-linux); {
      default = self.packages.x86_64-linux.ecuflash;

      ecuflash = callPackage ./ecuflash.nix {
        inherit mkWindowsAppNoCC;
        wine = wineWowPackages.full;
      };
    };

    apps.x86_64-linux.ecuflash = {
      type = "app";
      program = "${self.packages.x86_64-linux.ecuflash}/bin/ecuflash";
    };

    apps.x86_64-linux.default = self.apps.x86_64-linux.ecuflash;
  };
}