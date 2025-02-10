{ sys, ... }: let stack = "homeassistant"; in {
  home-manager.users."${sys.username}".home.file = {
    "${stack}" = {
      enable = true;
      recursive = true;
      source = ./.;
      target = "stacks/${stack}/";
    };
    "${stack}/.env" = {
      enable = true;
      text = ''APPDATA=${sys.dataDirs.appdata}/${stack}'';
      target = "stacks/${stack}/.env";
    };
  };
  sops.secrets."${stack}/mosquitto" = { 
    sopsFile = ./mosquitto.passwd;
    key = "";
    mode = "0440";
    format = "binary";
    owner = sys.username;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}