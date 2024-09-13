{ 
  description = "joey@joey-laptop";
  inputs = {  
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: 
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
          ./configuration.nix 
          inputs.home-manager.nixosModules.default
          inputs.hyprland.nixosModules.default
        ];
      };
    };
    homeConfigurations = {
      joey = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [ ./home.nix ];
      };
    };
  };
}
