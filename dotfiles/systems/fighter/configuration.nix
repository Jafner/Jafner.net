{ sys, ... }: {
  imports = [
    ./docker.nix
    ./hardware.nix
    ./network-shares.nix
    ./networking.nix
    ./server.nix
    ./stacks.nix
    ./terminal-environment.nix

    ../../modules/sops.nix
  ];

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  systemd.enableEmergencyMode = false;
  # DO NOT CHANGE
  system.stateVersion = "24.11";
  home-manager.users.${sys.username}.home.stateVersion = "24.11";
}