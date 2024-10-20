{ pkgs, inputs, systemSettings, ... }:
{
  # Configure system packages
  environment.systemPackages = with pkgs; [
    git
    networkmanagerapplet
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
  networking.hostName = "${systemSettings.hostname}";
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
}
