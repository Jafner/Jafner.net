{
  description = "Jafner.net Flake";
  inputs = {
    # Package repositories:
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    "nixpkgs-24.11".url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Applications:
    nixos-dns = {
      url = "github:Janik-Haag/nixos-dns";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixgl.url = "github:nix-community/nixGL";
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ self, ... }:
    {
      nixosConfigurations = {
        artificer =
          let
            username = "admin";
            hostname = "artificer";
            system = "x86_64-linux";
          in
          inputs.nixpkgs.lib.nixosSystem {
            modules = [
              "${inputs.nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
              # "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              # "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
              inputs.home-manager.nixosModules.home-manager
              inputs.sops-nix.nixosModules.sops
              inputs.nixos-dns.nixosModules.dns
              self.nixosModules.basicSystem
              self.nixosModules.stacks
              ./nixosConfigurations/artificer
              # TODO: Implement stack configuration (Traefik, UptimeKuma, Vaultwarden)
            ];
            inherit system;
            specialArgs = {
              inherit
                inputs
                username
                hostname
                system
                ;
            };
          };
        champion =
          let
            username = "admin";
            hostname = "champion";
            system = "x86_64-linux";
          in
          inputs.nixpkgs.lib.nixosSystem {
            modules = [
              "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
              inputs.home-manager.nixosModules.home-manager
              inputs.sops-nix.nixosModules.sops
              inputs.disko.nixosModules.disko
              self.nixosModules.basicSystem
              self.nixosModules.stacks
              {
                disko.devices = {
                  disk.primary = {
                    device = "/dev/vda";
                    type = "disk";
                    content = {
                      type = "gpt";
                      partitions = {
                        boot = {
                          size = "1M";
                          type = "EF02";
                        };
                        root = {
                          name = "root";
                          size = "100%";
                          content = {
                            type = "filesystem";
                            format = "ext4";
                            mountpoint = "/";
                          };
                        };
                      };
                    };
                  };
                };
              }
              ./nixosConfigurations/champion
            ];
            inherit system;
            specialArgs = {
              inherit
                inputs
                username
                hostname
                system
                ;
            };
          };
        fighter =
          let
            username = "admin";
            hostname = "fighter";
            system = "x86_64-linux";
          in
          inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit
                inputs
                username
                hostname
                system
                ;
            };
            modules = [
              inputs.home-manager.nixosModules.home-manager
              inputs.sops-nix.nixosModules.sops
              self.nixosModules.basicSystem
              self.nixosModules.stacks
              ./nixosConfigurations/fighter
            ];
          };
        desktop =
          let
            inherit inputs;
            username = "joey";
            hostname = "desktop";
            system = "x86_64-linux";
          in
          inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit
                inputs
                username
                hostname
                system
                ;
            };
            modules = [
              inputs.home-manager.nixosModules.home-manager
              inputs.sops-nix.nixosModules.sops
              inputs.chaotic.nixosModules.default
              self.nixosModules.basicSystem
              ./nixosConfigurations/desktop
            ];
          };
      };
      deploy = {
        nodes = {
          artificer = {
            hostname = "artificer";
            profilesOrder = [ "system" ];
            profiles.system = {
              user = "root";
              sshUser = "admin";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.artificer;
            };
          };
          champion = {
            hostname = "champion";
            profilesOrder = [ "system" ];
            profiles.system = {
              user = "root";
              sshUser = "admin";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.champion;
            };
          };
          desktop = {
            hostname = "desktop";
            profilesOrder = [ "system" ];
            profiles.system = {
              user = "root";
              sshUser = "joey";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.desktop;
            };
          };
          fighter = {
            hostname = "fighter";
            profilesOrder = [ "system" ];
            profiles.system = {
              user = "root";
              sshUser = "admin";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.fighter;
            };
          };
        };
        fastConnection = true;
        interactiveSudo = false;
        autoRollback = true;
        magicRollback = true;
        remoteBuild = false;
        confirmTimeout = 60;
      };
      nixosModules = {
        basicSystem = import ./modules/basicSystem.nix;
        stacks = import ./modules/stacks/default.nix;
      };
      packages = inputs.nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system: {
        sdwebui-rocm = inputs.nixpkgs.legacyPackages.${system}.callPackage ./pkgs/sdwebui-rocm { };
        helloworld = inputs.nixpkgs.legacyPackages.${system}.callPackage ./pkgs/helloworld { };
      });
      devShells = inputs.nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system: {
        default = inputs.nixpkgs.legacyPackages.${system}.mkShellNoCC {
          packages = with inputs.nixpkgs.legacyPackages.${system}; [
            inputs.deploy-rs.packages.${system}.deploy-rs
            yek
          ];
          nativeBuildInputs = [
            inputs.deploy-rs.packages.${system}.deploy-rs
          ];
        };
      });
      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      checks = builtins.mapAttrs (
        _system: deployLib: deployLib.deployChecks self.deploy
      ) inputs.deploy-rs.lib;
    };
}
