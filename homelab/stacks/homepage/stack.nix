{ sys, stacks, ... }: let stack = "homepage"; in {
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
}