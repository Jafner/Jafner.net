{ sys, ... }: let stack = "coder"; in {
  home-manager.users."${sys.username}".home.file = {
    "${stack}" = {
      enable = true;
      recursive = true;
      source = ./.;
      target = "stacks/${stack}/";
    };
    "${stack}/.env" = {
      enable = true;
      text = ''APPDATA=${sys.dataDirs.appdata}'';
      target = "stacks/${stack}/.env";
    };
  };
  sops.secrets."${stack}/postgres" = { 
    sopsFile = ./postgres.secrets;
    key = "";
    mode = "0440";
    owner = sys.username;
  };
  sops.secrets."${stack}/zipline" = { 
    sopsFile = ./zipline.secrets;
    key = "";
    mode = "0440";
    owner = sys.username;
  };
}