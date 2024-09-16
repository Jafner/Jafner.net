{ inputs, config, lib, pkgs, pkgs-unstable, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./security.nix
      ./flatpak.nix
      ./kde.nix
      ./steam.nix
      ./theming.nix
    ];
  
  # Configure mouse and touchpad
  services.libinput = {
    enable = true;
    mouse.naturalScrolling = true;
    touchpad.naturalScrolling = true;
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
  services.displayManager = {
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "joey";
    defaultSession = "plasma";
    sddm = {
      enable = true;
      autoNumlock = true;
    };
  }; 

  # Disable systemd's getty and autovt on tty1
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };  

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

  home-manager.users.joey = { pkgs, pkgs-unstable, ... }: {
    home.stateVersion = "24.05";

  };
  
  # Configure system packages
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

