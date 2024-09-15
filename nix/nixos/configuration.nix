{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./flatpak.nix
      ./kde.nix
      ./steam.nix
    ];
  
  environment.etc."current-system-packages".text = 
    let 
      packages = builtins.map (p: "${ p.name }") config.environment.systemPackages; 
      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages); 
      formatted = builtins.concatStringsSep "\n" sortedUnique; 
    in 
      formatted;     

  # Configure mouse and touchpad
  services.libinput.enable = true;
  services.libinput.mouse.naturalScrolling = true;
  services.libinput.touchpad.naturalScrolling = true;
  
  # Enable passwordless sudo
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

  # Enable SSH server with exclusively key-based auth
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Configure bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure networking
  networking.hostName = "joey-laptop";
  networking.networkmanager.enable = true;

  # Configure localization
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

  # Configure displayManager
  services.displayManager.autoLogin = {
    enable = true;
    user = "joey";
  };
  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
    settings.Autologin.Session = "plasma.desktop";
    settings.Autologin.User = "joey";
  }; 
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Configure X11 server 
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  # Enable printing service
  services.printing.enable = true;
  
  # Configure audio
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  # Configure user joey
  programs.zsh.enable = true;
  users.users.joey.shell = pkgs.zsh;
  users.users.joey = {
    isNormalUser = true;
    description = "joey";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  # Configure system packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    git
    waybar
    mako
    libnotify
    swww
    kitty
    rofi-wayland
    kdePackages.kdeconnect-kde
  ];

  # Configure XDG
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];
  
  # DO NOT CHANGE
  system.stateVersion = "24.05"; 

}

