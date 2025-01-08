{ pkgs, ... }: {
  home.packages = with pkgs; [ 
    vlc
    ffmpeg-full 
  ];
  services.flatpak.packages = [
      "no.mifi.losslesscut/x86_64/stable"
  ];
}
