{ pkgs, ... }: { 
  # Configure stylix
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  stylix.image = ./wallpaper.png;

  # Configure fonts
  fonts.packages = with pkgs; [
    nerdfonts
  ];
}
