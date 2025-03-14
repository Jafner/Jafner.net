{ pkgs, sys, ... }: {
  home-manager.users."${sys.username}" = {
    programs.rbw = {
      enable = true;
      settings = {
        base_url = "https://bitwarden.jafner.tools";
        email = "jafner425@gmail.com";
        lock_timeout = 2592000;
        pinentry = pkgs.pinentry-qt;
      };
    };
    programs.wofi.enable = true;
    home.packages = with pkgs; [
      rofi-rbw-wayland
    ];
    xdg.desktopEntries = {
      rofi-rbw = {
        exec = "${pkgs.rofi-rbw-wayland}/bin/rofi-rbw";
        icon = "/home/${sys.username}/.icons/custom/bitwarden.png";
        name = "Bitwarden";
        categories = [ "Utility" "Security" ];
        type = "Application";
      };
    };
    home.file = {
      "rofi-rbw.rc" = {
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
      "bitwarden.png" = {
        target = ".icons/custom/bitwarden.png";
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/bitwarden/clients/refs/heads/main/apps/desktop/resources/icons/64x64.png";
          sha256 = "sha256-ZEYwxeoL8doV4y3M6kAyfz+5IoDsZ+ci8m+Qghfdp9M=";
        };
      };
    };
  };
}