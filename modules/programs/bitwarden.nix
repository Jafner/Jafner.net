{ pkgs, config, ... }:
let
  cfg = config.modules.programs.bitwarden;
in
{
  options = with pkgs.lib; {
    modules.programs.bitwarden = {
      enable = mkEnableOption "Bitwarden";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
      bitwardenServerUrl = mkOption {
        type = types.str;
        default = "https://bitwarden.com";
        description = "URL of the Bitwarden server to connect to.";
        example = "https://bitwarden.mydomain.tld";
      };
      bitwardenEmail = mkOption {
        type = types.str;
        default = null;
        description = "Email to use to authenticate with the Bitwarden server.";
        example = "user@example.org";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    home-manager.users."${cfg.username}" = {
      programs.rbw = {
        enable = true;
        settings = {
          base_url = cfg.bitwardenServerUrl;
          email = cfg.bitwardenEmail;
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
          icon = "/home/${cfg.username}/.icons/custom/bitwarden.png";
          name = "Bitwarden";
          categories = [
            "Utility"
            "Security"
          ];
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
  };
}
