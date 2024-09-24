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
          vim fastfetch
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
          };
        };
        time.timeZone = "America/Los_Angeles";
        nix.settings.trusted-users = [ "root" "admin" ];
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        system.stateVersion = "24.05";
      };
      bard = { name, nodes, ... }: {
        imports = [ ./hosts/bard/hardware-configuration.nix ];
        deployment = {
          targetUser = "admin";
          targetHost = "192.168.1.31";
        };
        networking.hostName = "bard";
        networking.interfaces."enp1s0".macAddress = "6c:2b:59:37:89:40";
        networking.interfaces."enp1s0".ipv4.addresses = [ { address = "192.168.1.31"; prefixLength = 24; } ];
      };
      ranger = { name, nodes, ... }: {
        imports = [ ./hosts/ranger/hardware-configuration.nix ];
        deployment = {
          targetUser = "admin";
          targetHost = "192.168.1.32";
        };
        networking.hostName = "ranger";
        networking.interfaces."enp1s0".macAddress = "6c:2b:59:37:9e:91";
        networking.interfaces."enp1s0".ipv4.addresses = [ { address = "192.168.1.32"; prefixLength = 24; } ];
      };
      cleric = { name, nodes, ... }: {
        imports = [ ./hosts/cleric/hardware-configuration.nix ];
        deployment = {
          targetUser = "admin";
          targetHost = "192.168.1.33";
        };
        networking.hostName = "cleric";
        networking.interfaces."enp1s0".macAddress = "6c:2b:59:37:9e:00";
        networking.interfaces."enp1s0".ipv4.addresses = [ { address = "192.168.1.33"; prefixLength = 24; } ];
      };
    };
  };
}