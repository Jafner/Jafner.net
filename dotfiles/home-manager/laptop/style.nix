{ pkgs, vars, ... }:
{
  home.packages = with pkgs; [ base16-schemes ];
  ## Stylix 
  imports = [ ./themes/${vars.laptop.theme}/theme.nix ];
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    targets = {
      wofi.enable = true;
      waybar = {
        enableLeftBackColors = true;
        enableCenterBackColors = true;
        enableRightBackColors = true;
      };
    };
    fonts = {
      monospace = {
        name = "DejaVu Sans Mono";
        package = pkgs.dejavu_fonts;
      };
      serif = {
        name = "DejaVu Serif";
        package = pkgs.dejavu_fonts;
      };
      sansSerif = {
        name = "DejaVu Sans";
        package = pkgs.dejavu_fonts;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      sizes = {
        terminal = 14;
        applications = 12;
        popups = 12;
        desktop = 12;
      };
    };
  };
}
