{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };


  networking.hostName = "joey-laptop";

  users.users = {
    joey = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      ];
      extraGroups = ["wheel"];
    };
  };

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [{
        command = "ALL";
        options = [ "NOPASSWD" ];
      }];
      groups = [ "wheel" ];
    }];
  };  

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  system.stateVersion = "24.05";
}
