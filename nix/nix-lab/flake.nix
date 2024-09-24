{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };
  outputs = { nixpkgs, ... }: {
    colmena = { 
      meta = { 
        nixpkgs = import nixpkgs { system = "x86_64-linux"; }; 
      }; 
      defaults = { pkgs, ... }: { 
        environment.systemPackages = with pkgs; [
          vim
        ];
        security.sudo = {
          enable = true;
          extraRules = [{
            commands = [
              {
                command = "ALL";
                options = [ "NOPASSWD" ];
              }
            ];
            groups = [ "wheel" ];
          }];
        };
        services.openssh = {
          enable = true;
          settings.PasswordAuthentication = false;
          settings.KbdInteractiveAuthentication = false;
        };
        users.users = {
          admin = {
            isNormalUser = true;
            description = "admin";
            extraGroups = [ "networkmanager" "wheel" ];
            openssh.authorizedKeys.keys = let
              authorizedKeys = pkgs.fetchurl {
                url = "https://github.com/Jafner.keys";
                sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
              };
            in pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
          };
        };
        networking = {
          interfaces."enp1s0" = {
            useDHCP = true;
            ipv4.addresses = [ { prefixLength = 24; } ];
          };
        };
        time.timeZone = "America/Los_Angeles";
      };
      bard = { name, nodes, ... }: {
        deployment = {
          targetUser = "admin";
          targetHost = "192.168.1.31";
        };
        networking.hostName = "bard";
        networking.interfaces."enp1s0".macAddress = "6c:2b:59:37:89:40";
        networking.interfaces."enp1s0".ipv4.addresses.address = "192.168.1.31";
      };
      ranger = { name, nodes, ... }: {
        deployment = {
          targetUser = "admin";
          targetHost = "192.168.1.32";
        };
        networking.hostName = "ranger";
        networking.interfaces."enp1s0".macAddress = "6c:2b:59:37:9e:91";
        networking.interfaces."enp1s0".ipv4.addresses.address = "192.168.1.32";
      };
      cleric = { name, nodes, ... }: {
        deployment = {
          targetUser = "admin";
          targetHost = "192.168.1.33";
        };
        networking.hostName = "cleric";
        networking.interfaces."enp1s0".macAddress = "6c:2b:59:37:9e:00";
        networking.interfaces."enp1s0".ipv4.addresses.address = "192.168.1.33";
      };
    };
  };
}