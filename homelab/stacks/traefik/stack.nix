{ sys, ... }: let stack = "traefik"; in {
  home-manager.users."${sys.username}".home.file = {
    "${stack}/.env" = {
      enable = true;
      text = ''APPDATA=${sys.dataDirs.appdata}/${stack}'';
      target = "stacks/${stack}/.env";
    };
    "${stack}/config/config.yaml" = {
      enable = true;
      source = ./config/config.yaml;
      target = "stacks/${stack}/config/config.yaml";
    };
  };
  sops.secrets."${stack}" = { 
    sopsFile = ./traefik.secrets;
    key = "";
    mode = "0440";
    owner = sys.username;
  };
}