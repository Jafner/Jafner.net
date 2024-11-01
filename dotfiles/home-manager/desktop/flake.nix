{
  description = "Home Manager configuration of joey@joey-desktop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
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

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, nixgl, plasma-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        overlays = [ nixgl.overlay ];
        config = { allowUnfreePredicate = (_: true); }; 
      }; 
      pkgs-unstable = import nixpkgs-unstable {
        system = system;
        overlays = [ nixgl.overlay ];
        config = { allowUnfreePredicate = (_: true); };
      };
    in {
      homeConfigurations."joey" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./home.nix 
          inputs.sops-nix.homeManagerModules.sops
          inputs.stylix.homeManagerModules.stylix
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          inputs.plasma-manager.homeManagerModules.plasma-manager
        ];
        extraSpecialArgs = { inherit pkgs pkgs-unstable inputs vars; };
      };
    };
}
