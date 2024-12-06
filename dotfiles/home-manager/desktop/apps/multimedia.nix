{ pkgs, ... }: {
  home.packages = with pkgs; [ vlc ];
  services.flatpak.packages = [
      "no.mifi.losslesscut/x86_64/stable"
      "org.videolan.VLC/x86_64/stable"
  ];
}
