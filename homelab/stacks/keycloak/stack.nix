{ sys, stacks, ... }: let stack = "keycloak"; in {
  home-manager.users."${sys.username}".home.file = {
    "${stack}" = {
      enable = true;
      recursive = true;
      source = ./.;
      target = "stacks/${stack}/";
    };
    "${stack}/.env" = {
      enable = true;
      text = ''
        APPDATA=${stacks.appdata}/${stack}
      '';
      target = "stacks/${stack}/.env";
    };
  };
  sops.secrets."${stack}/keycloak" = { 
    sopsFile = ./keycloak.secrets;
    key = "";
    mode = "0440";
    owner = sys.username;
  };
  sops.secrets."${stack}/postgres" = { 
    sopsFile = ./postgres.secrets;
    key = "";
    mode = "0440";
    owner = sys.username;
  };
  sops.secrets."${stack}/forwardauth" = { 
    sopsFile = ./forwardauth.secrets;
    key = "";
    mode = "0440";
    owner = sys.username;
  };
  sops.secrets."${stack}/forwardauth-privileged" = { 
    sopsFile = ./forwardauth-privileged.secrets;
    key = "";
    mode = "0440";
    owner = sys.username;
  };
}