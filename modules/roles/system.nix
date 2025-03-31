{ pkgs, lib, config, username, hostname, ... }: with lib; let cfg = config.roles.system; in {
  options = {
    roles.system = {
      enable = mkEnableOption "Standard system";
      kernelPackage = mkOption {
        type = types.raw;
        default = pkgs.linuxKernel.packages."linux_6_13";
        description = "The Linux kernel package to use.";
        example = "pkgs.linuxKernel.packages.\"linux_zen\"";
      };
      authorizedKeysSource.url = mkOption {
        type = types.str;
        default = null;
        description = "URL from which to source authorized_keys. Must be plain text.";
        example = "https://github.com/MyUser.keys";
      };
      authorizedKeysSource.hash = mkOption {
        type = types.str;
        default = null;
        description = "Hash of authorized_keys content. Must be sha256.";
        example = "1i3Vs6mPPl965g4sRmbXYzx6zQMs5geBCgNx2zfpjF4=";
      };
      sshPrivateKeyPath = mkOption {
        type = types.str;
        default = ".ssh/id_ed_25519";
        description = "Path to private key to use for age. Relative to home of primary user.";
        example = ".ssh/me@example.tld";
      };
    };
  };
  config = mkIf cfg.enable {
    home-manager.users."${username}" = {
      home.packages = with pkgs; [
        sops
        age
        ssh-to-age
      ];
      home.stateVersion = "24.11";
    };
    sops = {
      age.sshKeyPaths = [ "/home/${username}/${cfg.sshPrivateKeyPath}" ];
      age.generateKey = false;
    };
    services.libinput = {
      enable = true;
      mouse.naturalScrolling = true;
      touchpad.naturalScrolling = true;
    };

    boot.kernelPackages = cfg.kernelPackage;
      # Read more: https://wiki.nixos.org/wiki/Linux_kernel
      # Other options:
      # - https://mynixos.com/nixpkgs/packages/linuxKernel.packages
      # - https://mynixos.com/nixpkgs/packages/linuxPackages

    environment.etc."current-nixos".source = ../.;
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
      extraGroups = [ "networkmanager" "wheel" ];
      description = "${username}";
      openssh.authorizedKeys.keys = pkgs.lib.splitString "\n" (builtins.readFile (pkgs.fetchurl {
        url = cfg.authorizedKeysSource.url; # https://github.com/Jafner.keys
        sha256 = cfg.authorizedKeysSource.hash; # 1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=
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

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.trusted-users = [ "root" "@wheel" ];
    nix.settings.auto-optimise-store = true;
    nix.extraOptions = ''
      accept-flake-config = true
      warn-dirty = false
    '';

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
  };
}
