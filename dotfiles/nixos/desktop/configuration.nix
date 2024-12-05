{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./addons/goxlr.nix
    ./addons/samba-client.nix
  ];
  
  # Configure user
  programs.zsh.enable = true;
  users.users.joey = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "joey";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = let
      authorizedKeys = pkgs.fetchurl {
        url = "https://github.com/Jafner.keys";
        sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
      };
    in pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };

  services.flatpak = {
    enable = true;  
    uninstallUnmanaged = true;
    remotes = [ { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; } ];
    packages = [
      "runtime/org.freedesktop.Platform.ffmpeg-full/x86_64/24.08"
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

  # Configure system packages
  environment.systemPackages = with pkgs; [
    git
    networkmanagerapplet
    steam
    steam-run
    lutris-unwrapped
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
  networking.hostName = "joey-desktop-nixos";
  networking.networkmanager.enable = true;

  # Disable systemd's getty and autovt on tty1
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
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

  # Configure XDG
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  nixpkgs.config.allowUnfree = true; 
  programs.steam.enable = true;

  programs.nix-ld = { 
    enable = true; 
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [];
  };
  hardware.amdgpu = {
    amdvlk.enable = true;
    opencl.enable = true;
  };


  # Configure displayManager
  services.displayManager.defaultSession = "plasma";
  services.displayManager = {
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "joey";
    sddm = {
      enable = true;
      autoNumlock = true;
    };
  }; 

  # Configure X11 server 
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Configure KDE Plasma 6
  services.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;
 
  # DO NOT CHANGE
  system.stateVersion = "24.11"; 
}

