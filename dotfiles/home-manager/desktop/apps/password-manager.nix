{ pkgs, ... }:
{
  home.packages = with pkgs; [ 
    rofi-rbw
    wl-clipboard
    dotool
  ];
  programs.tofi = {
    enable = false;
    settings = {};
  };
  programs.rofi = {
    enable = false;
  };
  programs.wofi = {
    enable = true;
  };

  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://bitwarden.jafner.tools";
      email = "jafner425@gmail.com";
      lock_timeout = 3600;
      pinentry = pkgs.pinentry-qt;
    };
  };
  # home.file."rofi-rbw.rc" = {
  #   target = ".config/rofi-rbw.rc";
  #   text = ''
  #   '';
  # };
  # };
} 

