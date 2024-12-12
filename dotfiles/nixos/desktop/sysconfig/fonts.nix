{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts 
    noto-fonts-cjk-sans
    noto-fonts-emoji
    powerline-symbols
    (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})  
  ];  
}
