{ sys, stacks, ... }: let stack = "manyfold"; in {
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
        LIBRARY=${stacks.library.digitalModels}/Model Library/VanDAM
      '';
      target = "stacks/${stack}/.env";
    };
  };
  sops.secrets."${stack}/manyfold" = { 
    sopsFile = ./manyfold.secrets;
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
}