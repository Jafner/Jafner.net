{ sys, stacks, ... }: let stack = "vaultwarden"; in {
  home-manager.users."${sys.username}".home.file = {
    "${stack}" = {
      enable = true;
      recursive = true;
      source = ./.;
      target = "stacks/${stack}/";
    };
    "${stack}/.env" = {
      enable = true;
      text = ''APPDATA=${stacks.appdata}/${stack}'';
      target = "stacks/${stack}/.env";
    };
  };
  sops.secrets."${stack}" = { 
    sopsFile = ./admin.token;
    key = "";
    format = "binary";
    mode = "0440";
    owner = sys.username;
  };
}