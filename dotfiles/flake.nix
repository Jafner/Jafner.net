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
    vars = {
      "joey-laptop" = {
        username = "joey";
        hostname = "joey-laptop";
        theme = "gruvbox-warm";
        wm = "hyprland";
      };
      "joey-desktop" = {
        realname = "Joey Hafner";
        username = "joey";
        hostname = "joey-desktop";
        email = "joey@jafner.net";
      };
    };
  };
  outputs = inputs@{ 
    nixpkgs, 
    nixpkgs-unstable, 
    home-manager, 
    nixgl,
    plasma-manager,
    ... 
  }:
  let
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
      joey-laptop = lib.nixosSystem {        
        modules = [ 
          ./nixos/joey-laptop/configuration.nix 
          inputs.hyprland.nixosModules.default
          inputs.stylix.nixosModules.stylix
          inputs.nix-flatpak.nixosModules.nix-flatpak
        ];
        inherit system;
        specialArgs = { 
          inherit pkgs;
          inherit pkgs-unstable; 
          inherit inputs; 
        };
      };
    };
    homeConfigurations = {
      "joey-laptop" = home-manager.lib.homeManagerConfiguration {
        modules = [ 
          ./home-manager/joey-laptop/home.nix 
          inputs.stylix.homeManagerModules.stylix 
          inputs.plasma-manager.homeManagerModules.plasma-manager
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
        ];
        inherit pkgs; 
        extraSpecialArgs = { 
          inherit pkgs;
          inherit pkgs-unstable; 
          inherit inputs; 
        };
      };
      "joey-desktop" = home-manager.lib.homeManagerConfiguration {
        modules = [ 
          ./home-manager/joey-desktop/home.nix 
          inputs.sops-nix.homeManagerModules.sops
          inputs.stylix.homeManagerModules.stylix
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          inputs.plasma-manager.homeManagerModules.plasma-manager
        ];
        inherit pkgs;
        extraSpecialArgs = { 
          inherit pkgs;
          inherit pkgs-unstable;
          inherit inputs; 
        };
      };
    };
  };
}

