{ 

  description = "My flake";
  inputs = {  
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
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