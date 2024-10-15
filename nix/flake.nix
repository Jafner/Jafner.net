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
  };
  outputs = inputs@{ 
    nixpkgs, 
    nixpkgs-unstable, 
    home-manager, 
    ... 
  }:
  let
    systemSettings = {
      system = "x86_64-linux";
      hostname = "joey-laptop";
    };
    userSettings = {
      user = "joey";
      theme = "gruvbox-warm";
      wm = "hyprland";
    };
    lib = nixpkgs.lib;
    pkgs = import inputs.nixpkgs {
        system = systemSettings.system;
        config = { allowUnfreePredicate = (_: true); };
    };
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${systemSettings.system};
    

  in {
    nixosConfigurations = {
      ${systemSettings.hostname} = lib.nixosSystem {        
        modules = [ 
          ./nixos/configuration.nix 
          inputs.hyprland.nixosModules.default
          inputs.stylix.nixosModules.stylix
          inputs.nix-flatpak.nixosModules.nix-flatpak
        ];
        system = systemSettings.system;
        specialArgs = { 
          inherit pkgs;
          inherit pkgs-unstable; 
          inherit systemSettings;
          inherit userSettings;
          inherit inputs; 
        };
      };
    };
    homeConfigurations = {
      ${userSettings.user} = home-manager.lib.homeManagerConfiguration {
        modules = [ 
          ./home-manager/home.nix 
          inputs.stylix.homeManagerModules.stylix 
          inputs.plasma-manager.homeManagerModules.plasma-manager
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
        ];
        inherit pkgs; 
        extraSpecialArgs = { 
          inherit pkgs;
          inherit pkgs-unstable; 
          inherit systemSettings;
          inherit userSettings;
          inherit inputs; 
        };
      };
    };
  };
}

