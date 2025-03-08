{
  description = "Joey's Flake";
  inputs = {
    # Package repositories:
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications:
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixgl.url = "github:nix-community/nixGL";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
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
    ghostty.url = "github:ghostty-org/ghostty";
    nixos-dns = {
      url = "github:Janik-Haag/nixos-dns";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixgl,
    ghostty,
    deploy-rs,
    self, 
    ...
  }: {
    nixosConfigurations = {
      desktop = let
        sys = {
          username = "joey";
          hostname = "desktop";
          kernelPackage = "linux_zen"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
          sshPrivateKey = ".ssh/joey.desktop@jafner.net";
          repoPath = "Jafner.net";
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ nixgl.overlay ];
          config = { allowUnfreePredicate = (_: true); };
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          overlays = [ nixgl.overlay ];
          config = { allowUnfreePredicate = (_: true); };
        };
        in nixpkgs.lib.nixosSystem {
          modules = [
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            {
              home-manager.sharedModules = [
                inputs.nix-flatpak.homeManagerModules.nix-flatpak
                inputs.stylix.homeManagerModules.stylix
              ];
              home-manager.extraSpecialArgs = { inherit pkgs pkgs-unstable inputs sys; };
            }
            { nix.settings.download-buffer-size = 1073741824; }
            ./modules/system.nix
            ./modules/git.nix
            ./modules/sops.nix
            ./modules/docker.nix
            ./modules/smb.nix
            ./modules/iscsi.nix
            ./modules/networking.nix
            ./applications/minecraft-server.nix
            ./applications/spotify.nix
            ./modules/flatpak.nix
            ./applications/minecraft-server.nix
            ./hosts/desktop/configuration.nix
            ./hosts/desktop/desktop-environment.nix
            ./hosts/desktop/terminal-environment.nix
            ./hosts/desktop/theme.nix
            ./hosts/desktop/filesystems.nix
            ./hosts/desktop/defaultApplications.nix
            ./hosts/desktop/clips.nix
            ./hosts/desktop/hosts.nix
            ./hosts/desktop/sshconfig.nix
            ./hosts/desktop/hardware/audio.nix
            ./hosts/desktop/hardware/goxlr-mini.nix
            ./hosts/desktop/hardware/libinput.nix
            ./hosts/desktop/hardware/printing.nix
            ./hosts/desktop/hardware/razer.nix
            ./hosts/desktop/hardware/wooting.nix
            ./hosts/desktop/hardware/xpad.nix
            ./hosts/desktop/hardware.nix
          ];
          inherit system;
          specialArgs = { 
            inherit pkgs pkgs-unstable inputs; 
            sys = sys;
            docker = { 
              username = sys.username; 
            };
            sops = { 
              username = sys.username; 
              sshPrivateKey = sys.sshPrivateKey; 
              repoRoot = "/home/joey/Git/Jafner.net"; 
            };
            git = { 
              username = sys.username; 
              realname = "Joey Hafner"; 
              email = "joey@jafner.net"; 
              sshPrivateKey = sys.sshPrivateKey; 
              signingKey = "B0BBF464024BCEAE"; 
            };
            smb = {
              secretsFile = ./hosts/desktop/smb.secrets;
              automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
              permissions_opts = "credentials=/run/secrets/smb,uid=1000,gid=1000";
            };
            iscsi = {
              iqn = "iqn.2020-03.net.jafner:joey-desktop";
              portalIP = "192.168.1.12:3260";
              mountPath = "/mnt/iscsi"; # Unused until I can figure out how to write a proper iscsi fileSystems block.
              fsType = "ext4"; # Unused until I can figure out how to write a proper iscsi fileSystems block.
            };
            networking = {
              hostname = sys.hostname;
              interface = "enp4s0f0";
              mac = "90:e2:ba:e3:f7:94";
              ip = "192.168.1.135";
              gatewayIP = "192.168.1.1";
              dns = [ "10.0.0.1" ];
            };
          };
        };
      artificer = let 
        sys = {
          username = "admin";
          hostname = "artificer";
          kernelPackage = "linux_6_12"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
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
        in nixpkgs.lib.nixosSystem {
          modules = [
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            ./modules/system.nix
            ./modules/git.nix
            ./modules/sops.nix
            ./modules/docker.nix
            ./services/gitea/stack.nix
            ./services/gitea-runner/stack.nix
            ./services/vaultwarden/stack.nix
            ./services/monitoring/stack.nix
            ./services/traefik/stack.nix
            "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
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
            };
            repo = {
              path = "Jafner.net"; # Path to copy repo, relative to home.
            };
            traefik = {
              configFile = ./hosts/artificer/traefik_config.yaml;
            };
          };
        };
      champion = let 
        sys = {
          username = "admin";
          hostname = "champion";
          kernelPackage = "linux_6_12"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
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
        in nixpkgs.lib.nixosSystem {
          modules = [
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            inputs.disko.nixosModules.disko
            "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
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
        sys = {
          username = "admin";
          hostname = "fighter";
          sshPrivateKey = ".ssh/admin@fighter";
          kernelPackage = "linux_6_12"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
          repoPath = "Jafner.net";
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = { allowUnfreePredicate = (_: true); allowUnfree = true; };
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
        in nixpkgs.lib.nixosSystem {
          modules = [
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            inputs.nixos-dns.nixosModules.dns
            ./modules/system.nix 
            ./modules/git.nix 
            ./modules/sops.nix
            ./modules/docker.nix
            ./modules/networking.nix 
            ./modules/smb.nix
            ./modules/iscsi.nix
            ./services/ai/stack.nix
            ./services/autopirate/stack.nix
            ./services/gitea-runner/stack.nix
            ./services/homeassistant/stack.nix
            ./services/keycloak/stack.nix
            ./services/manyfold/stack.nix
            ./services/minecraft/stack.nix
            ./services/monitoring/stack.nix
            ./services/navidrome/stack.nix
            ./services/plex/stack.nix
            ./services/qbittorrent/stack.nix
            ./services/send/stack.nix
            ./services/stash/stack.nix
            ./services/traefik/stack.nix
            ./services/unifi/stack.nix
            ./services/wireguard/stack.nix
            ./services/zipline/stack.nix
            ./hosts/fighter/hardware.nix
            ./hosts/fighter/terminal-environment.nix
          ];
          inherit system;
          specialArgs = { 
            inherit inputs pkgs pkgs-unstable;
            sys = sys; 
            networking = {
              hostname = sys.hostname;
              interface = "enp3s0";
              mac = "00:02:c9:56:bf:9a";
              ip = "192.168.1.23";
              gatewayIP = "192.168.1.1";
              dns = [ "10.0.0.1" ];
            };
            stacks = {
              appdata = "/appdata";
              library = {
                digitalModels = "/mnt/3DPrinting";
                av = "/mnt/av";
                books = "/mnt/books";
                movies = "/mnt/movies";
                music = "/mnt/music";
                shows = "/mnt/shows";
                torrenting = "/mnt/torrenting";
              };
            };
            traefik = {
              configFile = ./hosts/artificer/traefik_config.yaml;
            };
            docker = { 
              username = sys.username; 
            };
            sops = { 
              username = sys.username; 
              sshPrivateKey = sys.sshPrivateKey; 
              repoRoot = "/home/admin/Jafner.net"; 
            };
            git = { 
              username = sys.username; 
              realname = sys.hostname; 
              email = "noreply@jafner.net"; 
              sshPrivateKey = sys.sshPrivateKey; 
              signingKey = ""; 
            };
            smb = {
              secretsFile = ./hosts/fighter/smb.secrets;
              automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
              permissions_opts = "credentials=/run/secrets/smb,uid=1000,gid=1000";
            };
            iscsi = {
              iqn = "iqn.2020-03.net.jafner:fighter";
              portalIP = "192.168.1.12:3260";
              mountPath = "/mnt/iscsi"; # Unused until I can figure out how to write a proper iscsi fileSystems block.
              fsType = "ext4"; # Unused until I can figure out how to write a proper iscsi fileSystems block.
            };
            gitea-runner = {
              tokenFile = ./hosts/fighter/registration.token;
            };
          };
        };
      # build with:
      # nix build .#nixosConfigurations.iso.config.system.build.isoImage
      iso = let 
        sys = {
          username = "admin";
          hostname = "installer";
          kernelPackage = "linux_6_12"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
          sshPrivateKey = ".ssh/joey.desktop@jafner.net";
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
        in nixpkgs.lib.nixosSystem {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            inputs.home-manager.nixosModules.home-manager
            ./modules/system.nix
          ];
          inherit system;
          specialArgs = { 
            inherit pkgs pkgs-unstable inputs; 
            sys = sys;
          };
        };

      # build with:
      # nix build .#nixosConfigurations.cloudimage.config.system.build.digitalOceanImage
      cloudimage = let 
        sys = {
          username = "admin";
          hostname = "digital-ocean";
          kernelPackage = "linux_6_12"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
          sshPrivateKey = ".ssh/joey.desktop@jafner.net";
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
        in nixpkgs.lib.nixosSystem {
          modules = [
            "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
            inputs.home-manager.nixosModules.home-manager
            ./modules/system.nix
          ];
          inherit system;
          specialArgs = { 
            inherit pkgs pkgs-unstable inputs;
            sys = sys; 
          };
        };
    };
    deploy = {
      nodes = {
        artificer = { # deploy with nix run github:serokell/deploy-rs -- --targets dotfiles#artificer
          hostname = "artificer";
          profilesOrder = [ "system" ];
          profiles.system = {
            user = "root";
            sshUser = "admin";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.artificer;
          };
        };
        champion = { # deploy with nix run github:serokell/deploy-rs -- --targets dotfiles#champion
          hostname = "champion";
          profilesOrder = [ "system" ];
          profiles.system = {
            user = "root";
            sshUser = "admin";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.champion;
          };
        };
        fighter = { # deploy with nix run github:serokell/deploy-rs -- --targets dotfiles#fighter
          hostname = "fighter";
          profilesOrder = [ "system" ];
          profiles.system = {
            user = "root";
            sshUser = "admin";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.fighter;
          };
        };
        desktop = { # deploy with nix run github:serokell/deploy-rs -- --targets dotfiles#desktop
          hostname = "desktop";
          profilesOrder = [ "system" ];
          profiles.system = {
            user = "root";
            sshUser = "joey";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.desktop;
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
    # packages = {
    #   zoneFiles = inputs.nixos-dns.utils.generate nixpkgs.legacyPackages."x86_64-linux".zoneFiles {
    #     inherit (self) nixosConfigurations;
    #     extraConfig = import ./dns.nix;
    #   };
    # };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
