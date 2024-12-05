{ pkgs, ... }: {
  home.packages = with pkgs; [ base16-schemes ];
  stylix = {
    enable = true;
    autoEnable = false;
    polarity = "dark";
    image = ./plasma6.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
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
    };
    targets = {
      bat.enable = true;
      btop.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      gtk.enable = true;
      kde.enable = false; # Currently, this breaks most of KDE.
      kitty.enable = true;
      tmux.enable = true;
      vesktop.enable = true;
      vim.enable = true;
      vscode.enable = true;
    };
  };
}
