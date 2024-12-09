{ vars, pkgs, ... }:
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
      lock_timeout = 604800;
      pinentry = pkgs.pinentry-qt;
    };
  };

  xdg.desktopEntries = {
    rofi-rbw = {
      exec = "${pkgs.rofi-rbw}/bin/rofi-rbw";
      icon = "/home/${vars.user.username}/.icons/custom/bitwarden.png"; 
      name = "Bitwarden";
      categories = [ "Utility" "Security" ]; 
      type = "Application";
    };
  };
  
  home.file."rofi-rbw.rc" = {
    target = ".config/rofi-rbw.rc";
    text = ''
    action="type"
    typing-key-delay=5
    no-folder
    selector-args="-W 40% -H 30%"
    selector="wofi"
    clipboarder="wl-copy"
    typer="dotool"
    '';
  };

  home.file."bitwarden.png" = {
    target = ".icons/custom/bitwarden.png";
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/bitwarden/clients/refs/heads/main/apps/desktop/resources/icons/64x64.png";
      sha256 = "sha256-ZEYwxeoL8doV4y3M6kAyfz+5IoDsZ+ci8m+Qghfdp9M=";
    };
  };
} 

