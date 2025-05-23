{
  description = "Jafner.net Flake";
  inputs = {
    # Package repositories:
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications:
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };
  outputs = inputs @ { self, ... }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
    in
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
              inputs.home-manager.nixosModules.home-manager
              inputs.sops-nix.nixosModules.sops
              ./nixosConfigurations/artificer
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
              ./nixosConfigurations/fighter
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
      packages = forAllSystems (system: {
        sdwebui-rocm = inputs.nixpkgs.legacyPackages.${system}.callPackage ./pkgs/sdwebui-rocm { };
        helloworld = inputs.nixpkgs.legacyPackages.${system}.callPackage ./pkgs/helloworld { };
      });
      devShells = forAllSystems (system: {
        default = inputs.nixpkgs.legacyPackages.${system}.mkShellNoCC {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          packages = with inputs.nixpkgs.legacyPackages.${system}; [
            inputs.deploy-rs.packages.${system}.deploy-rs
            yek
          ] ++ self.checks.${system}.pre-commit-check.enabledPackages;
          nativeBuildInputs = [
            inputs.deploy-rs.packages.${system}.deploy-rs
          ];
        };
      });
      apps = forAllSystems (system: {
        # nix run .#deploy
        deploy = {
          type = "app";
          program = toString (
            inputs.nixpkgs.legacyPackages.${system}.writers.writeBash "deploy" ''
              ${inputs.deploy-rs.packages.${system}.deploy-rs}/bin/deploy
            ''
          );
        };
        # nix run .#fmt
        fmt = {
          type = "app";
          program = toString (
            inputs.nixpkgs.legacyPackages.${system}.writers.writeBash "fmt" ''
              nix fmt .
            ''
          );
        };
        # nix run .#compare
        compare = {
          type = "app";
          program = toString (
            inputs.nixpkgs.legacyPackages.${system}.writers.writeBash "compare" ''
              echo "Info: "
              WD=$(pwd); cd /tmp; nixos-rebuild build --flake github:Jafner/Jafner.net; cd $WD
              nix store diff-closures $(readlink -f /run/current-system) $(readlink -f /tmp/result)
            ''
          );
        };
        # nix run .#sops <list|updatekeys|rotate|edit|show|usedby>
        sops = {
          type = "app";
          program = toString (
            inputs.nixpkgs.legacyPackages.${system}.writers.writeBash "sops" ''
              if ! [[ -f .sops.yaml  ]]; then echo "Can't find .sops.yaml. Are you in the root of the repo?"; exit 1; fi
              case "$1" in
                list) find "${self.outPath}" -type f -regextype posix-extended -iregex "^.*(\.(secrets|token|passwd)|secrets.env|config.boot)" ;;
                updatekeys) find "$(pwd)" -type f -regextype posix-extended -iregex "^.*(\.(secrets|token|passwd)|secrets.env|config.boot)" -exec sops updatekeys {} \; ;;
                rotate) find "$(pwd)" -type f -regextype posix-extended -iregex "^.*(\.(secrets|token|passwd)|secrets.env|config.boot)" -exec sops rotate -i {} \; ;;
                edit) # If a path is specified, edit it. Otherwise, fzf existing repo secrets.
                  if ! [[ -z $2 ]]; then
                    sops edit "$2";
                  else
                    find . -type f -regextype posix-extended -iregex "^.*(\.(secrets|token|passwd)|secrets.env|config.boot)" | fzf --preview 'sops decrypt {}' --bind 'enter:become(sops edit {})'
                  fi
                  ;;
                show)
                  sops decrypt \
                    "$(find "." -type f -regextype posix-extended -iregex "^.*(\.(secrets|token|passwd)|secrets.env|config.boot)" |\
                      fzf --preview 'sops decrypt {}'\
                    )" |\
                    tee /dev/fd/2 |\
                    wl-copy
                ;;
                usedby)
                  FILE=$2
                  if [[ -z $2 ]]; then
                    FILE="$(
                      find "." -type f -regextype posix-extended -iregex "^.*(\.(secrets|token|passwd)|secrets.env|config.boot)" |\
                      fzf --preview-window wrap --preview 'rg --context=0 -l "$(basename {})"' --header "Files referencing selected file -->"
                    )"
                  fi
                  rg --context=0 -l "$(basename $FILE)"
                ;;
                *) echo "No command specified." ;;
              esac
            ''
          );
        };
      });
      formatter.x86_64-linux =
        (inputs.treefmt-nix.lib.evalModule inputs.nixpkgs.legacyPackages.x86_64-linux {
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true; # **.nix
          programs.deadnix.enable = true; # **.nix
        }).config.build.wrapper;
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            # shellcheck.enable = true;
            # mdsh.enable = true;
            nixpkgs-fmt.enable = true;
            deadnix.enable = true;
          };
        };
        deploy-check = (inputs.deploy-rs.lib.${system}.deployChecks self.deploy).deploy-activate;
      });
    };
}
