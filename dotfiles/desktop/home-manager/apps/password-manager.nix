{ vars, pkgs, ... }:
{
  home.packages = with pkgs; [ 
    rofi-rbw-wayland
    wl-clipboard
    dotool
  ];
  programs.tofi = {
    enable = false;
    settings = {};
  };
  programs.rofi = {
    enable = false;
    configPath = "$XDG_CONFIG_HOME/rofi/config.rasi";
    extraConfig = {};
    location = "center";
    terminal = "${pkgs.kitty}/bin/kitty";
  };
  programs.wofi = {
    enable = true;
  };

  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://bitwarden.jafner.tools";
      email = "jafner425@gmail.com";
      lock_timeout = 2592000;
      pinentry = pkgs.pinentry-qt;
    };
  };

  xdg.desktopEntries = {
    rofi-rbw = {
      exec = "${pkgs.rofi-rbw-wayland}/bin/rofi-rbw";
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
    typing-key-delay=0
    selector-args="-W 40% -H 30%"
    selector="wofi"
    clipboarder="wl-copy"
    typer="dotool"
    keybindings="Enter:type:username:enter:tab:type:password:enter:copy:totp"
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

