{ sys, ... }: let stack = "ai"; in {
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
}