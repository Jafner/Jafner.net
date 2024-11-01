{ 
  description = "Joey's Flake";
  inputs = {  
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-conf-editor = {
      url = "github:snowfallorg/nixos-conf-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs"; 
  };
  outputs = inputs@{ 
    nixpkgs, 
    nixpkgs-unstable, 
    home-manager, 
    nixgl,
    ... 
  }:
  let
    vars = {
      user = {
        username = "joey";
        realname = "Joey Hafner";
        email = "joey@jafner.net";
      };
      laptop = {
        hostname = "joey-laptop";
        theme = "gruvbox-warm";
      };
      desktop = {
        hostname = "joey-desktop";
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
          inputs.sops-nix.homeManagerModules.sops
          inputs.stylix.homeManagerModules.stylix
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          inputs.plasma-manager.homeManagerModules.plasma-manager
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

