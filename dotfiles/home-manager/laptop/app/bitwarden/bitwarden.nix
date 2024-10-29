{ pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs; [
    rofi-rbw-wayland 
    rbw 
    pinentry-rofi
    pinentry-all
  ];
  home.file = {
    rbw-config = {
      target = ".config/rbw/config.json";
      text = ''
      {
        "email": "jafner425@gmail.com",
        "sso_id": null,
        "base_url": "https://bitwarden.jafner.tools",
        "identity_url": null,
        "ui_url": null,
        "notifications_url": null,
        "lock_timeout": 3600,
        "sync_interval": 3600,
        "pinentry": "pinentry-curses",
        "client_cert_path": null
      }
      '';
    };
  };
} 
