{ sys, ... }: let stack = "stash"; in {
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
        APPDATA=${sys.dataDirs.appdata}/${stack}
        LIBRARY=${sys.dataDirs.library.av}
      '';
      target = "stacks/${stack}/.env";
    };
  };
}