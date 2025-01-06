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
    ...
  }:
  let
    vars = {
      repo = {
        gitServerHttp = "https://gitea.jafner.tools";
        gitServerSsh = "ssh://git@gitea.jafner.tools:2225";
        owner = "Jafner";
        repoName = "Jafner.net";
        branch = "main";
        flakePath = "dotfiles/flake.nix";
      };
      flakeRepo = "$HOME/Git/Jafner.net";
      flakeDir = "$HOME/Git/Jafner.net/dotfiles";
      user = {
        username = "joey";
        realname = "Joey Hafner";
        email = "joey@jafner.net";
        keys = {
          gpgSigningKey = "$HOME/.keys/joey@jafner.net.desktop.sign.gpg";
          gpgSigningKeyFingerprint = "B0BBF464024BCEAE";
          gpgEncryptKey = "$HOME/.keys/joey@jafner.net.encrypt.gpg";
          sshKey = "$HOME/.keys/joey.desktop@jafner.net";
          ageKey = "$HOME/.keys/joey.author.key";
        };
      };
      laptop = {
        hostname = "joey-laptop";
        theme = "gruvbox-warm";
        sshKey = "joey.laptop@jafner.net";
      };
    };
    system = "x86_64-linux";
    lib = nixpkgs.lib;
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
  in {
    nixosConfigurations = {
      # Build nixos-installer with:
      # nix build .#nixosConfigurations.nixos-installer.config.system.build.isoImage
      nixos-installer = let
        sysVars = {
          username = "nixos-installer";
          arch = "x86_64-linux";
        };
        in lib.nixosSystem {
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          ./nixos-installer.nix
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.home-manager.nixosModules.home-manager
          { home-manager = {
              users.nixos-installer = import ./nixos-installer.hm.nix;
              sharedModules = [
                inputs.nix-flatpak.homeManagerModules.nix-flatpak
                inputs.stylix.homeManagerModules.stylix
              ];
              extraSpecialArgs = { inherit pkgs pkgs-unstable inputs; inherit vars sysVars; };
          }; }
        ];
        inherit system;
        specialArgs = {
          inherit pkgs pkgs-unstable inputs;
          inherit vars;
        };
      };
      desktop = let sysVars = {
        username = "joey";
        arch = "x86_64-linux";
        hostname = "joey-desktop-nixos";
        sshKey = "joey.desktop@jafner.net";
        signingKey = "B0BBF464024BCEAE";
        kernelPackage = "linux_zen"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
        wallpaper = ./assets/romb-3840x2160.png;
      }; in lib.nixosSystem {
        modules = [
          ./desktop/nixos/configuration.nix
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.joey = import ./desktop/home-manager/home.nix;
              sharedModules = [
                inputs.nix-flatpak.homeManagerModules.nix-flatpak
                inputs.stylix.homeManagerModules.stylix
              ];
              extraSpecialArgs = { inherit pkgs pkgs-unstable inputs; inherit vars sysVars; };
            };
          }
        ];
        inherit system;
        specialArgs = { inherit pkgs pkgs-unstable inputs vars sysVars; };
      };
      desktop-refactored = let sysVars = {
        username = "joey";
        arch = "x86_64-linux";
        hostname = "joey-desktop-nixos";
        sshKey = "joey.desktop@jafner.net";
        signingKey = "B0BBF464024BCEAE";
        kernelPackage = "linux_zen"; # Read more: https://nixos.wiki/wiki/Linux_kernel; Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages;
        wallpaper = ./assets/romb-3840x2160.png;
      }; in lib.nixosSystem {
        modules = [
          ./desktop-refactored.nix
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules = [
                inputs.nix-flatpak.homeManagerModules.nix-flatpak
                inputs.stylix.homeManagerModules.stylix
              ];
              extraSpecialArgs = { inherit pkgs pkgs-unstable inputs; inherit vars sysVars; };
          }
        ];
        inherit system;
        specialArgs = { inherit pkgs pkgs-unstable inputs; inherit vars sysVars; };
      };
    };
    homeConfigurations = {
      laptop = home-manager.lib.homeManagerConfiguration {
        modules = [
          ./home-manager/laptop/home.nix
          inputs.stylix.homeManagerModules.stylix
          inputs.plasma-manager.homeManagerModules.plasma-manager
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
        ];
        inherit pkgs;
        extraSpecialArgs = {
          inherit pkgs pkgs-unstable inputs;
          inherit vars;
        };
      };
      desktop = home-manager.lib.homeManagerConfiguration {
        modules = [
          ./home-manager/desktop/home.nix
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
        ];
        inherit pkgs;
        extraSpecialArgs = {
          inherit pkgs pkgs-unstable inputs;
          inherit vars;
        };
      };
    };
  };
}
