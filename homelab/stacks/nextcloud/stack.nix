{ sys, ... }: let stack = "nextcloud"; in {
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
  sops.secrets."${stack}/mariadb" = { 
    sopsFile = ./mariadb.secrets;
    key = "";
    mode = "0440";
    owner = sys.username;
  };
}