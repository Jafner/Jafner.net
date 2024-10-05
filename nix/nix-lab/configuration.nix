{ pkgs, hostConf, inputs, ... }: {
  #imports = [ inputs.sops-nix.nixosModules.sops ];
  # sops = {
  #   defaultSopsFile = ./secrets/secrets.yaml;
  #   defaultSopsFormat = "yaml";
  #   age.keyFile = "../../../.sops/nix.key";
  #   secrets."k3s.token" = { };
  # };
  environment.systemPackages = with pkgs; [
    vim 
    fastfetch
    tree 
    btop
    bat 
    fd 
    eza
    fzf
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
    hostName = "${hostConf.name}";
    interfaces."${hostConf.nic.name}" = {
      useDHCP = true;
      macAddress = "${hostConf.nic.mac}";
      ipv4.addresses = [ { address = "${hostConf.nic.ip}"; prefixLength = 24; } ];
    };
  };
  time.timeZone = "America/Los_Angeles";
  nix.settings.trusted-users = [ "root" "admin" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "24.05";
}