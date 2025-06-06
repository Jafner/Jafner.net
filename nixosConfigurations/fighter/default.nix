{ pkgs
, username
, hostname
, system
, ...
}: {
  imports =
    [
      ./filesystems.nix
      ./filesync
      ./git.nix
      ./hardware.nix
      ./home-manager.nix
      ./networking.nix
    ]
    ++ [
      ./infra.nix
    ];

  sops = {
    age.sshKeyPaths = [ "/home/${username}/.ssh/${username}@${hostname}" ];
    age.generateKey = false;
  };

  boot.kernelPackages = pkgs.linuxKernel.packages."linux_6_13";
  # Read more: https://wiki.nixos.org/wiki/Linux_kernel
  # Other options:
  # - https://mynixos.com/nixpkgs/packages/linuxKernel.packages
  # - https://mynixos.com/nixpkgs/packages/linuxPackages

  environment.etc."current-nixos".source = ../../.;
  environment.systemPackages = with pkgs; [
    coreutils
    git
    tree
    htop
    file
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

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    description = "${username}";
    openssh.authorizedKeys.keys = pkgs.lib.splitString "\n" (builtins.readFile ../../keys.txt); # Equivalent to `curl https://github.com/Jafner.keys > /home/$USER/.ssh/authorized_keys`
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
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

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    settings.trusted-users = [
      "root"
      "@wheel"
    ];
    settings.auto-optimise-store = true;
    extraOptions = ''
      accept-flake-config = true
      warn-dirty = false
    '';
  };

  networking.hostName = hostname;
  networking.hosts = {
    "192.168.1.1" = [ "wizard" ];
    "192.168.1.12" = [ "paladin" ];
    "192.168.1.23" = [ "fighter" ];
    "192.168.1.135" = [ "desktop" ];
    "143.198.68.202" = [ "artificer" ];
    "172.245.108.219" = [ "champion" ];
  };

  system.stateVersion = "24.11";

  # User Programs
  programs.nh = {
    enable = true;
    flake = "/home/${username}/Jafner.net";
  };
  home-manager.users."${username}" = {
    programs.home-manager.enable = true;
    programs.nnn.enable = true;
    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
    };
    home = {
      enableNixpkgsReleaseCheck = false;
      preferXdgDirectories = true;
      username = "${username}";
      homeDirectory = "/home/${username}";
      packages = with pkgs; [
        sops
        age
        ssh-to-age
        nvd
      ];
    };
    xdg.systemDirs.data = [ "/usr/share" ];
    home.stateVersion = "24.11";
  };

  nix.settings.download-buffer-size = 1073741824;
  nixpkgs = {
    hostPlatform = system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}
