{ sys, stacks, traefik, ... }: let stack = "traefik"; in {
  # Requires manually creating a docker network for 172.18.0.0/24
  # docker network create web --subnet 172.18.0.0/24
  home-manager.users."${sys.username}".home.file = {
    "${stack}/.env" = {
      enable = true;
      text = ''APPDATA=${stacks.appdata}/${stack}'';
      target = "stacks/${stack}/.env";
    };
    "${stack}" = {
      enable = true;
      recursive = true;
      source = ./.;
      target = "stacks/${stack}/";
    };
    "${stack}/config.yaml" = {
      enable = true;
      source = traefik.configFile;
      target = "stacks/${stack}/config.yaml";
    };
  };
  sops.secrets."${stack}" = { 
    sopsFile = ./traefik.secrets;
    key = "";
    mode = "0440";
    owner = sys.username;
  };
}