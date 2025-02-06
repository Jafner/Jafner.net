{ sys, pkgs, inputs, flake, ... }: {
  imports = [
    ./hardware.nix
    ./desktop-environment.nix
    ./terminal-environment.nix
    ./theme.nix
    ./filesystems.nix
    ./defaultApplications.nix
    ./ai.nix
    ../../modules/programs/spotify.nix
    ../../modules/sops.nix
    ../../modules/services/ssh.nix
    ../../modules/services/flatpak.nix
    ../../modules/services/minecraft-server.nix
    ../../modules/hardware/audio.nix
    ../../modules/hardware/goxlr-mini.nix
    ../../modules/hardware/libinput.nix
    ../../modules/hardware/network-shares.nix
    ../../modules/hardware/printing.nix
    ../../modules/hardware/razer.nix
    ../../modules/hardware/wooting.nix
    ../../modules/hardware/xpad.nix
  ];

  environment.sessionVariables = {
    "FLAKE_DIR" = "/home/${sys.username}/${flake.repoPath}/${flake.path}/";
  };

  home-manager.backupFileExtension = "bk";
  home-manager.users."${sys.username}" = {
    nixGL = {
      vulkan.enable = true;
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
    };
    home = {
      enableNixpkgsReleaseCheck = false;
      preferXdgDirectories = true;
      username = "${sys.username}";
      homeDirectory = "/home/${sys.username}";
    };
    xdg.systemDirs.data = [
      "/usr/share"
    ];
    programs.home-manager.enable = true;
    home.stateVersion = "24.11";
  };

  users.users."${sys.username}" = {
    isNormalUser = true;
    description = "${sys.username}";
    extraGroups = [ "networkmanager" "wheel" "input" ];
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

  programs.ydotool = {
    enable = true;
    group = "wheel";
  };

  systemd.enableEmergencyMode = false;

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

  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    powerline-symbols
    (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    dates = "04:00";
    randomizedDelaySec = "30min";
  };


  # DO NOT CHANGE
  system.stateVersion = "24.11";
}
