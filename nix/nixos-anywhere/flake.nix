{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }: {
    nixosConfigurations.bard = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        { disko.devices.disk.disk1.device = "/dev/mmcblk0"; }
        { 
          networking = {
            hostName = "bard"; 
            interfaces."enp1s0" = {
              useDHCP = true;
              macAddress = "6c:2b:59:37:89:40";
              ipv4.addresses = [ { address = "192.168.1.31"; prefixLength = 24; } ];
            };
          };
        }
        ./configuration.nix
      ];
    };
    nixosConfigurations.cleric = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        { disko.devices.disk.disk1.device = "/dev/sda"; }
        { 
          networking = {
            hostName = "cleric"; 
            interfaces."enp1s0" = {
              useDHCP = true;
              macAddress = "6c:2b:59:37:9e:00";
              ipv4.addresses = [ { address = "192.168.1.33"; prefixLength = 24; } ];
            };
          };
        }
        ./configuration.nix
      ];
    };
  };
}
