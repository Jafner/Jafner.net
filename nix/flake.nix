{ 
  description = "Joey's Flake";
  inputs = {  
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-conf-editor.url = "github:snowfallorg/nixos-conf-editor";
    nixos-conf-editor.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ 
    nixpkgs, 
    nixpkgs-unstable, 
    hyprland,
    home-manager, 
    nix-flatpak,
    stylix,
    ... 
  }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  in {
    nixosConfigurations = {
      joey-laptop = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable; inherit inputs; };
        modules = [ 
          ./nixos/configuration.nix 
          inputs.hyprland.nixosModules.default
          inputs.stylix.nixosModules.stylix
          inputs.nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    homeConfigurations = {
      joey = home-manager.lib.homeManagerConfiguration {
        inherit pkgs, pkgs-unstable;
        modules = [ ./home-manager/joey.nix ];
      };
    };
    };
  };
}
