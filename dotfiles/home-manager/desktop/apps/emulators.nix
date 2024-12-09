{ pkgs, ... }: {
  home.packages = with pkgs; [ 
    dolphin-emu 
    mgba
    desmume
  ];
}