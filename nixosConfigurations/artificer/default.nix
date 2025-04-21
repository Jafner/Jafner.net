{
  pkgs,
  username,
  hostname,
  system,
  ...
}:
{
  imports = [
    ./git.nix
    ./traefik.nix
    ./vaultwarden.nix
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f222513b-ded1-49fa-b591-20ce86a2fe7f";
    fsType = "ext4";
  };

  sops = {
    age.sshKeyPaths = [ "/home/${username}/.ssh/${username}@${hostname}" ];
    age.generateKey = false;
  };

  boot.kernelPackages = pkgs.linuxKernel.packages."linux_6_13";
  # Read more: https://wiki.nixos.org/wiki/Linux_kernel
  # Other options:
  # - https://mynixos.com/nixpkgs/packages/linuxKernel.packages
  # - https://mynixos.com/nixpkgs/packages/linuxPackages

  networking = {
    hostName = hostname;
    firewall.allowedUDPPorts = [ 80 443 ];
    firewall.allowedTCPPorts = [ 80 443 ];
  };
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
      "docker"
    ];
    description = "${username}";
    openssh.authorizedKeys.keys = pkgs.lib.splitString "\n" (
      builtins.readFile ../../keys.txt
    ); # Equivalent to `curl https://github.com/Jafner.keys > /home/$USER/.ssh/authorized_keys`
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



  system.stateVersion = "24.11";
  virtualisation.docker.enable = true;

  # User Programs
  programs.nh.enable = true;
  home-manager.users."${username}" = {
    programs.home-manager.enable = true;
    programs.nnn.enable = true;
    home = {
      enableNixpkgsReleaseCheck = false;
      preferXdgDirectories = true;
      username = "${username}";
      homeDirectory = "/home/${username}";
    };
    xdg.systemDirs.data = [ "/usr/share" ];
    home.stateVersion = "24.11";
  };

  nix = {
    settings = {
      download-buffer-size = 1073741824;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
    };
    extraOptions = ''
      accept-flake-config = true
      warn-dirty = false
    '';
  };
  nixpkgs = {
    hostPlatform = system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
}
