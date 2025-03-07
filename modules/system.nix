{ sys, pkgs, pkgs-unstable, ... }: {

  boot.kernelPackages = pkgs.linuxKernel.packages."${sys.kernelPackage}";
  
  environment.etc."current-nixos".source = ../.;
  environment.systemPackages = with pkgs; [
    git
    fastfetch
    dig
    btop
    vim
    tree
  ];

  programs.nix-ld.enable = true;
  systemd.enableEmergencyMode = false;

  # Enable SSH server with exclusively key-based auth
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  users.users."${sys.username}" = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    description = "${sys.username}";
    openssh.authorizedKeys.keys = pkgs.lib.splitString "\n" (builtins.readFile (pkgs.fetchurl {  
      url = "https://github.com/Jafner.keys"; 
      sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4="; 
    })); # Equivalent to `curl https://github.com/Jafner.keys > /home/$USER/.ssh/authorized_keys`
  };

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

  nix.package = pkgs-unstable.nixVersions.latest;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "@wheel" ];

  networking.hostName = sys.hostname;

  system.stateVersion = "24.11";
  home-manager.users."${sys.username}" = { 
    home.stateVersion = "24.11";
  };
}