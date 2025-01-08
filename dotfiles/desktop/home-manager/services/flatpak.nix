{ pkgs, ... }: {
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    remotes = [
      { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
    ];
    packages = [  ];
  };
  home.packages = with pkgs; [ flatpak ];
}