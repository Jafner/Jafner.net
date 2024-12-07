{ pkgs, ... }: {
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    okular
    discover
  ];
}