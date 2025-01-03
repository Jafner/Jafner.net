{
  description = "Joey's Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    stylix = {
      type = "github";
      owner = "danth";
      repo = "stylix";
      rev = "90f95c5d8408360fc38cb3a862565bcb08ae6aa8"; # Before breaking commit that inits ghostty
      #rev = "6eb0597e345a7f4a16f7d7b14154fc151790b419"; 
      #url = "github:danth/stylix";
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
      desktop = {
        hostname = "joey-desktop";
        sshKey = "joey.desktop@jafner.net";
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
      installer = lib.nixosSystem {
        modules = [
          ./nixos/installer/configuration.nix
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.joey = import ./home-manager/installer/home.nix;
              sharedModules = [
                inputs.nix-flatpak.homeManagerModules.nix-flatpak
                inputs.stylix.homeManagerModules.stylix
              ];
              extraSpecialArgs = { inherit pkgs pkgs-unstable inputs; inherit vars; };
            };
          }
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
        ];
        inherit system;
        specialArgs = {
          inherit pkgs pkgs-unstable inputs;
          inherit vars;
        };
      };
      desktop = lib.nixosSystem {
        modules = [
          ./nixos/desktop/configuration.nix
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.joey = import ./home-manager/desktop/home.nix;
              sharedModules = [
                inputs.nix-flatpak.homeManagerModules.nix-flatpak
                inputs.stylix.homeManagerModules.stylix
              ];
              extraSpecialArgs = { inherit pkgs pkgs-unstable inputs; inherit vars; };
            };
          }
        ];
        inherit system;
        specialArgs = {
          inherit pkgs pkgs-unstable inputs;
          inherit vars;
        };
      };
      laptop = lib.nixosSystem {
        modules = [
          ./nixos/laptop/configuration.nix
          inputs.hyprland.nixosModules.default
          #inputs.stylix.nixosModules.stylix
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.joey = import ./home-manager/laptop/home.nix;
              sharedModules = [
                inputs.nix-flatpak.homeManagerModules.nix-flatpak
                inputs.stylix.homeManagerModules.stylix
              ];
              extraSpecialArgs = { inherit pkgs pkgs-unstable inputs; inherit vars; };
            };
          }
        ];
        inherit system;
        specialArgs = {
          inherit pkgs pkgs-unstable inputs;
          inherit vars;
        };
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
