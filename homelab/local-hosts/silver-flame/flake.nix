{
  inputs = {
    deploy-rs.url = "github:serokell/deploy-rs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, deploy-rs, ... }: 
  let 
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs { 
      system = system;
      config = { allowUnfreePredicate = (_: true); };
    };
    pkgs-unstable = import inputs.nixpkgs-unstable { 
      system = system;
      config = { allowUnfreePredicate = (_: true); };
    };
  in 
  {
    nixosConfigurations = {
      bard = nixpkgs.lib.nixosSystem {
        modules = [ ./configuration.nix ./hosts/bard/hardware-configuration.nix ];
        inherit system;
        specialArgs = { 
          inherit pkgs; 
          inherit pkgs-unstable; 
          inherit inputs;
          hostConf = {
            name = "bard";
            nic.mac = "6c:2b:59:37:89:40";
            nic.ip = "192.168.1.31";
            nic.name = "enp1s0";
          };
        };
      };
      ranger = nixpkgs.lib.nixosSystem { 
        modules = [ ./configuration.nix ./hosts/ranger/hardware-configuration.nix ];
        inherit system;
        specialArgs = { 
          inherit pkgs; 
          inherit pkgs-unstable; 
          inherit inputs;
          hostConf = {
            name = "ranger";
            nic.mac = "6c:2b:59:37:9e:91";
            nic.ip = "192.168.1.32";
            nic.name = "enp1s0";
          };
        };
      };
      cleric = nixpkgs.lib.nixosSystem { 
        modules = [ ./configuration.nix ./hosts/cleric/hardware-configuration.nix ];
        inherit system;
        specialArgs = { 
          inherit pkgs; 
          inherit pkgs-unstable; 
          inherit inputs;
          hostConf = {
            name = "cleric";
            nic.mac = "6c:2b:59:37:9e:00";
            nic.ip = "192.168.1.33";
            nic.name = "enp1s0";
          };
        };
      };
    };
    deploy = {
      nodes = {
        bard = {
          hostname = "192.168.1.31";
          profilesOrder = [ "system" ];
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.bard;
        };
        ranger = {
          hostname = "192.168.1.32";
          profilesOrder = [ "system" ];
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ranger;
        };
        cleric = {
          hostname = "192.168.1.33";
          profilesOrder = [ "system" ];
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.cleric;
        };
      };
      sshUser = "root";
      user = "root";
      fastConnection = true;
      autoRollback = true;
      magicRollback = true;
      remoteBuild = true;
      confirmTimeout = 60;
    };
    devShells."x86_64-linux".default = pkgs.mkShell {
      packages = [ 
        pkgs.nixfmt-rfc-style 
        #(builtins.getFlake "github:serokell/deploy-rs").packages."x86_64-linux".deploy-rs
          # sha256-3KyjMPUKHkiWhwR91J1YchF6zb6gvckCAY1jOE+ne0U=
          # fetchFromGitHub {
          # >   owner = "serokell";
          # >   repo = "deploy-rs";
          # >   rev = "aa07eb0";
          # >   sha256 = "sha256:0000000000000000000000000000000000000000000000000000";
          # > }
      ];
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}