{ 
  description = "Joey's Flake";
  inputs = {  
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";
  };
  outputs = { 
    self, 
    nixpkgs, 
    nixpkgs-stable, 
    nixpkgs-unstable, 
    home-manager, 
    hyprland, 
    ... 
  }@inputs: 
    let 
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
    nixosConfigurations = {
      joey-laptop = lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = system;
        modules = [ 
          ./nixos/configuration.nix 
          inputs.home-manager.nixosModules.default
          inputs.hyprland.nixosModules.default
        ];
      };
    };
    homeConfigurations = {
      joey = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [ ./home-manager/home.nix ];
      };
    };
  };
}