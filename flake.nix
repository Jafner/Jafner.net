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
    # nur = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
    #nix-flatpak.url = "github:gmodena/nix-flatpak";
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
  outputs = inputs@{ nixpkgs, self, ... }: {
    nixosConfigurations = {
      artificer = let
        sys = {
          username = "admin";
          hostname = "artificer";
          sshPrivateKey = ".ssh/admin@artificer";
          repoPath = "Jafner.net";
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
        in inputs.nixpkgs.lib.nixosSystem {
          modules = [
            "${inputs.nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            inputs.nixos-dns.nixosModules.dns
            ./modules/system.nix
            ./modules/git.nix
            ./modules/sops.nix
            ./modules/docker.nix
            ./services/gitea/stack.nix
            ./services/gitea-runner/stack.nix
            ./services/vaultwarden/stack.nix
            ./services/monitoring/stack.nix
            ./services/traefik/stack.nix
          ];
          inherit system;
          specialArgs = {
            inherit inputs pkgs pkgs-unstable;
            sys = sys;
            git = {
              username = sys.username;
              realname = sys.hostname;
              email = "noreply@jafner.net";
              sshPrivateKey = sys.sshPrivateKey;
              signingKey = "";
            };
            sops = {
              username = sys.username;
              sshPrivateKey = sys.sshPrivateKey;
              repoRoot = "/home/admin/Jafner.net";
            };
            docker = {
              username = sys.username;
            };
            stacks = {
              appdata = "/appdata";
              monitoring = {

              };
            };
            repo = {
              path = "Jafner.net"; # Path to copy repo, relative to home.
            };
            traefik = {
              configFile = ./hosts/artificer/traefik_config.yaml;
            };
            gitea-runner = {
              tokenFile = ./hosts/artificer/registration.token;
            };
          };
        };
      champion = let
        sys = {
          username = "admin";
          hostname = "champion";
          sshPrivateKey = ".ssh/admin@champion";
          repoPath = "Jafner.net";
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
        in inputs.nixpkgs.lib.nixosSystem {
          modules = [
            "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            inputs.disko.nixosModules.disko
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
            ./modules/system.nix
            ./modules/git.nix
            ./modules/sops.nix
            ./modules/docker.nix
          ];
          inherit system;
          specialArgs = {
            inherit inputs pkgs pkgs-unstable;
            sys = sys;
            git = {
              username = sys.username;
              realname = sys.hostname;
              email = "noreply@jafner.net";
              sshPrivateKey = sys.sshPrivateKey;
              signingKey = "";
            };
            sops = {
              username = sys.username;
              sshPrivateKey = sys.sshPrivateKey;
              repoRoot = "/home/admin/Jafner.net";
            };
            docker = {
              username = sys.username;
            };
          };
        };
      fighter = let
        username = "admin";
        hostname = "fighter";
        system = "x86_64-linux";
        in inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username hostname system; };
          modules = [
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            self.nixosModules.basicSystem
            self.nixosModules.stacks
            ./nixosConfigurations/fighter
          ];
        };
      desktop = let
        inherit inputs;
        username = "joey";
        hostname = "desktop";
        system = "x86_64-linux";
        in inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs username hostname system; };
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
        artificer = { # deploy with nix run github:serokell/deploy-rs -- --targets .#artificer
          hostname = "artificer";
          profilesOrder = [ "system" ];
          profiles.system = {
            user = "root";
            sshUser = "admin";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.artificer;
          };
        };
        champion = { # deploy with nix run github:serokell/deploy-rs -- --targets .#champion
          hostname = "champion";
          profilesOrder = [ "system" ];
          profiles.system = {
            user = "root";
            sshUser = "admin";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.champion;
          };
        };
        desktop = { # deploy with nix run github:serokell/deploy-rs -- --targets .#desktop
          hostname = "desktop";
          profilesOrder = [ "system" ];
          profiles.system = {
            user = "root";
            sshUser = "joey";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.desktop;
          };
        };
        fighter = { # deploy with nix run github:serokell/deploy-rs -- --targets .#fighter
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
    packages = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system: {
      sdwebui-rocm = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/sdwebui-rocm { };
      helloworld = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/helloworld { };
    });
    devShells = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system: {
      default = nixpkgs.legacyPackages.${system}.mkShellNoCC {
        packages = with nixpkgs.legacyPackages.${system}; [
          inputs.deploy-rs.packages.${system}.deploy-rs
          yek
        ];
        nativeBuildInputs = [
          inputs.deploy-rs.packages.${system}.deploy-rs
        ];
      };
    });
    checks = builtins.mapAttrs
      (system:
        deployLib:
          deployLib.deployChecks
            self.deploy
      )
      inputs.deploy-rs.lib;
  };
}
