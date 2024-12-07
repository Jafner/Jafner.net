{ pkgs, ... }: {
  home.packages = with pkgs; [ base16-schemes ];
  # Use the following before running a switch to prevent clobbering:
  # rm ~/.gtkrc-2.0 ~/.config/gtk-3.0/settings.ini ~/.config/gtk-3.0/gtk.css ~/.config/gtk-4.0/settings.ini ~/.config/gtk-4.0/gtk.css
  # if one run with backups has already been done, clean it up with:
  # rm ~/.gtkrc-2.0.backup ~/.config/gtk-3.0/settings.ini.backup ~/.config/gtk-3.0/gtk.css.backup ~/.config/gtk-4.0/settings.ini.backup ~/.config/gtk-4.0/gtk.css.backup
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    #image = ./plasma6-2560x1440.png;
    image = ./romb-3840x2160.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    fonts = {
      sizes = {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 12;
      };
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
    };
    targets = {
      bat.enable = true;
      btop.enable = true;
      firefox.enable = true;
      firefox.profileNames = [ "Default" ];
      fzf.enable = true;
      gnome.enable = true;
      gtk.enable = true;
      kde.enable = true; 
      rofi.enable = true;
      vesktop.enable = true;
      vscode.enable = true;
      wofi.enable = true;
    };
  };
}
