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
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ nixgl.overlay ];
          config = { allowUnfreePredicate = (_: true); };
        };
      in nixpkgs.lib.nixosSystem {
        modules = [
          ./systems/desktop/configuration.nix
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          {
            home-manager.sharedModules = [
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
              inputs.stylix.homeManagerModules.stylix
            ];
            home-manager.extraSpecialArgs = { inherit pkgs inputs sys; };
          }
          ./modules/system.nix
          ./modules/git.nix
          ./modules/sops.nix
          ./modules/docker.nix
          ./modules/smb.nix
          ./modules/iscsi.nix
          ./modules/networking.nix
          ./modules/services/minecraft-server.nix
          ./modules/programs/spotify.nix
          ./modules/services/flatpak.nix
          ./modules/services/minecraft-server.nix
          ./systems/desktop/hardware/audio.nix
          ./systems/desktop/hardware/goxlr-mini.nix
          ./systems/desktop/hardware/libinput.nix
          ./systems/desktop/hardware/printing.nix
          ./systems/desktop/hardware/razer.nix
          ./systems/desktop/hardware/wooting.nix
          ./systems/desktop/hardware/xpad.nix
          ./systems/desktop/hardware.nix
          ./systems/desktop/desktop-environment.nix
          ./systems/desktop/terminal-environment.nix
          ./systems/desktop/theme.nix
          ./systems/desktop/filesystems.nix
          ./systems/desktop/defaultApplications.nix
          ./systems/desktop/clips.nix
        ];
        inherit system;
        specialArgs = { inherit pkgs inputs; 
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
            secretsFile = ./systems/desktop/smb.secrets;
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

      # # build with:
      # # nix build .#nixosConfigurations.iso.config.system.build.isoImage
      # iso = let 
      #   sys = {
      #     username = "admin";
      #     hostname = "installer";
      #     signingKey = "";
      #     kernelPackage = "linux_6_12"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
      #     sshPrivateKey = ".ssh/joey.desktop@jafner.net";
      #   };
      #   system = "x86_64-linux";
      #   pkgs = import inputs.nixpkgs {
      #     inherit system;
      #     config = { allowUnfreePredicate = (_: true); };
      #   };
      # in nixpkgs.lib.nixosSystem {
      #   modules = [
      #     "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      #     "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      #     { imports = [ ./modules/system.nix ]; }
      #   ];
      #   inherit system pkgs;
      #   specialArgs = { inherit sys; };
      # };

      # # build with:
      # # nix build .#nixosConfigurations.cloudimage.config.system.build.digitalOceanImage
      # cloudimage = let 
      #   sys = {
      #     username = "admin";
      #     hostname = "digital-ocean";
      #     signingKey = "";
      #     kernelPackage = "linux_6_12"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
      #     sshPrivateKey = ".ssh/joey.desktop@jafner.net";
      #   };
      #   system = "x86_64-linux";
      #   pkgs = import inputs.nixpkgs {
      #     inherit system;
      #     config = { allowUnfreePredicate = (_: true); };
      #   };
      # in nixpkgs.lib.nixosSystem {
      #   modules = [
      #     "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
      #     { imports = [ ./modules/system.nix ]; }
      #   ];
      #   inherit system pkgs;
      #   specialArgs = { inherit sys; };
      # };
      # artificer = let 
      #   sys = {
      #     username = "admin";
      #     hostname = "artificer";
      #     signingKey = "";
      #     kernelPackage = "linux_6_12"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
      #     sshPrivateKey = ".ssh/admin@artificer";
      #   };
      #   system = "x86_64-linux";
      #   pkgs = import inputs.nixpkgs {
      #     inherit system;
      #     config = { allowUnfreePredicate = (_: true); };
      #   };
      # in nixpkgs.lib.nixosSystem {
      #   modules = [
      #     ./systems/artificer/configuration.nix
      #     inputs.home-manager.nixosModules.home-manager
      #     inputs.sops-nix.nixosModules.sops
      #     "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
      #     { imports = [ ./modules/system.nix ]; 
      #       sys = sys; }
      #     { imports = [ ./modules/git.nix ]; 
      #       git = { 
      #         username = sys.username; 
      #         realname = sys.hostname; 
      #         email = "noreply@jafner.net"; 
      #         sshPrivateKey = sys.ssyPrivateKey; 
      #         signingKey = ""; 
      #       }; }
      #     { imports = [ ./modules/sops.nix ]; 
      #       sops = { 
      #         username = sys.username; 
      #         sshPrivateKey = sys.sshPrivateKey; 
      #         repoRoot = "/home/admin/Jafner.net"; 
      #       }; }
      #     { imports = [ ./modules/docker.nix ]; 
      #       docker = { 
      #         username = sys.username; 
      #       }; }
      #   ];
      #   inherit system pkgs;
      #   specialArgs = { inherit sys; };
      # };
      fighter = let 
        sys = {
          username = "admin";
          hostname = "fighter";
          sshPrivateKey = ".ssh/admin@fighter";
          kernelPackage = "linux_6_12"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = { allowUnfreePredicate = (_: true); allowUnfree = true; };
        };
      in nixpkgs.lib.nixosSystem {
        modules = [
          ./systems/fighter/hardware.nix
          ./systems/fighter/stacks.nix
          ./systems/fighter/terminal-environment.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          ./modules/system.nix 
          ./modules/git.nix 
          ./modules/sops.nix
          ./modules/docker.nix
          ./systems/fighter/stacks.nix
          ./modules/networking.nix 
          ./modules/smb.nix
          ./modules/iscsi.nix
        ];
        inherit system pkgs;
        specialArgs = { 
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
            secretsFile = ./systems/fighter/smb.secrets;
            automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
            permissions_opts = "credentials=/run/secrets/smb,uid=1000,gid=1000";
          };
          iscsi = {
            iqn = "iqn.2020-03.net.jafner:fighter";
            portalIP = "192.168.1.12:3260";
            mountPath = "/mnt/iscsi"; # Unused until I can figure out how to write a proper iscsi fileSystems block.
            fsType = "ext4"; # Unused until I can figure out how to write a proper iscsi fileSystems block.
          };
        };
      };
    };
    deploy = {
      nodes = {
        artificer = {
          hostname = "143.198.68.202";
          profilesOrder = [ "system" ];
          profiles.system = {
            user = "root";
            sshUser = "admin";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.artificer;
          };
        };
      };
      fastConnection = true;
      interactiveSudo = false;
      autoRollback = true;
      magicRollback = true;
      remoteBuild = true;
      confirmTimeout = 60;
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
