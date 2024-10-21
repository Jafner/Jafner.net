{ pkgs, ... }:
{
  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config.allowUnfree = true;
  };
  imports = [  ];
  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };
  };
  home-manager.users.admin = { pkgs, ... }: {
    home.packages = with pkgs; [ ];
    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
  };
  users.users = {
    admin = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = let
        authorizedKeys = pkgs.fetchurl {
          url = "https://github.com/Jafner.keys";
          sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
        };
      in pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
    };
  };
  environment.systemPackages = with pkgs; [
    vim 
    fastfetch 
    tree
    btop
    bat
    fd
    eza
    fzf
    cifs-utils
    dig
    git
    ( writeShellScriptBin "nix-installer" '' 
      #!/usr/bin/env bash
      set -euo pipefail
      if [ "$(id -u)" -eq 0 ]; then
        echo "$ERROR! $(basename "$0") should be run as a regular user"
        exit 1
      fi
      if [ ! -d "$HOME/Jafner.net/.git" ]; then
        git clone https://gitea.jafner.tools "$HOME/Jafner.net"
      fi

      

      sudo nixos-install --flake "$HOME/Jafner.net/nix"
    '' )
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking = {
    wireless = { enable = false; };
    hostName = "nixos-installer";
    networkmanager.enable = true;
  };
  security = {
    sudo = {
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
    rtkit.enable = true;
  };
  time.timeZone = "America/Los_Angeles";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  }; 
  boot.loader = { 
    systemd-boot.enable = true; 
    efi.canTouchEfiVariables = true;
  };
  # DO NOT CHANGE
  system.stateVersion = "24.05"; 
}

