{
  description = "A Nix flake with tools for working with ECUs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = let
      pkgs = import "${nixpkgs}" {
        system = "x86_64-linux";
      };
    in with pkgs; {
      default = self.packages.x86_64-linux.ecuflash;
      j2534 = callPackage ./j2534.nix {
        inherit libusb1 pkg-config;
        inherit fetchFromGitHub;
        inherit stdenv;
      };
      romraider = callPackage ./romraider.nix {
        inherit fetchFromGitHub;
        inherit stdenv;
      };
    };

    apps.x86_64-linux.romraider = {
      type = "app";
      program = "${self.packages.x86_64-linux.romraider}/bin/romraider";
    };

    apps.x86_64-linux.default = self.apps.x86_64-linux.ecuflash;
  };
}