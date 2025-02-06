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
  }:
  let
    flake = {
      gitServer.http = "https://gitea.jafner.tools";
      gitServer.ssh = "ssh://git@gitea.jafner.tools:2225";
      owner = "Jafner";
      repoName = "Jafner.net";
      branch = "main";
      repoPath = "Git/Jafner.net";
      path = "dotfiles/flake.nix";
    };
    usr.joey = {
      realname = "Joey Hafner";
      email = "joey@jafner.net";
      encryptKey = "$HOME/.keys/joey@jafner.net.encrypt.gpg";
      ageKey = "$HOME/.keys/joey.author.key";
    };
    usr.admin = {
      realname = "admin";
      email = "noreply@jafner.net";
    };
    jafnerKeys = let file = (import inputs.nixpkgs { system = "x86_64-linux"; }).fetchurl {
        url = "https://github.com/Jafner.keys";
        sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
    }; in inputs.nixpkgs.lib.splitString "\n" (builtins.readFile file);
  in {
    nixosConfigurations = {
      desktop = let
        sys = {
          username = "joey";
          hostname = "desktop";
          sshKey = "/home/joey/.ssh/joey.desktop@jafner.net";
          signingKey = "B0BBF464024BCEAE";
          shellPackage = "zsh";
          kernelPackage = "linux_zen"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
          wallpaper = ./assets/romb-3840x2160.png;
          arch = "x86_64-linux";
          flakeDir = "Git/Jafner.net/dotfiles";
          authorizedKeys = jafnerKeys;
          dockerData = "/home/joey/docker/data";
          ssh = {
            path = "/home/joey/.ssh";
            privateKey = "joey.desktop@jafner.net";
            publicKey = "joey.desktop@jafner.net.pub";
          };
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ nixgl.overlay ];
          config = { allowUnfreePredicate = (_: true); };
        };
        pkgs-unstable = import nixpkgs-unstable {
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
            home-manager.extraSpecialArgs = { inherit pkgs pkgs-unstable inputs; inherit sys usr flake; };
          }
          
        ];
        inherit system;
        specialArgs = { inherit pkgs pkgs-unstable inputs sys usr flake; };
      };

      # build with:
      # nix build .#nixosConfigurations.iso.config.system.build.isoImage
      iso = let 
        sys = {
          username = "admin";
          authorizedKeys = jafnerKeys;
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
      in nixpkgs.lib.nixosSystem {
        modules = [
          #"${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          {
            system.stateVersion = "24.11";
            environment.systemPackages = with pkgs; [
              git
            ];
            users.users."${sys.username}" = {
              isNormalUser = true;
              extraGroups = [ "networkmanager" "wheel" ];
              description = "${sys.username}";
              openssh.authorizedKeys.keys = sys.authorizedKeys;
            };
            services.openssh = {
              enable = true;
              settings.PasswordAuthentication = false;
              settings.KbdInteractiveAuthentication = false;
            };
            security.sudo = {
              enable = true;
              extraRules = [{
                commands = [
                  {
                    command = "ALL";
                    options = [ "NOPASSWD" ];
                  }
                ];
                groups = [ "wheel" ];
              }];
            };
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
          }
        ];
        inherit system pkgs;
        specialArgs = { inherit sys; };
      };

      # build with:
      # nix build .#nixosConfigurations.cloudimage.config.system.build.digitalOceanImage
      cloudimage = let 
        sys = {
          username = "admin";
          authorizedKeys = jafnerKeys;
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
      in nixpkgs.lib.nixosSystem {
        modules = [
          "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
          {
            system.stateVersion = "24.11";
            environment.systemPackages = with pkgs; [
              git
            ];
            users.users."${sys.username}" = {
              isNormalUser = true;
              extraGroups = [ "networkmanager" "wheel" ];
              description = "${sys.username}";
              openssh.authorizedKeys.keys = sys.authorizedKeys;
            };
            services.openssh = {
              enable = true;
              settings.PasswordAuthentication = false;
              settings.KbdInteractiveAuthentication = false;
            };
            security.sudo = {
              enable = true;
              extraRules = [{
                commands = [
                  {
                    command = "ALL";
                    options = [ "NOPASSWD" ];
                  }
                ];
                groups = [ "wheel" ];
              }];
            };
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
          }
        ];
        inherit system pkgs;
        specialArgs = { inherit sys; };
      };
      artificer = let 
        sys = {
          username = "admin";
          authorizedKeys = jafnerKeys;
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
      in nixpkgs.lib.nixosSystem {
        modules = [
          ./systems/artificer/configuration.nix
          "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
        ];
        inherit system pkgs;
        specialArgs = { inherit sys; };
      };
      fighter = let 
        sys = {
          username = "admin";
          hostname = "fighter";
          authorizedKeys = jafnerKeys;
          shellPackage = "bash";
          networking = {
            ifname = "enp3s0";
            mac = "00:02:C9:56:BF:9A";
            ip = "192.168.1.23";
          };
          ssh = {
            privateKey = ".ssh/admin@fighter";
          };
          dataDirs = {
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
          kernelPackage = "linux_6_12"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
      in nixpkgs.lib.nixosSystem {
        modules = [
          ./systems/fighter/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
        ];
        inherit system pkgs;
        specialArgs = { inherit sys flake; };
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
