{ sys, stacks, ... }: let stack = "stash"; in {
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
        LIBRARY=${stacks.library.av}
      '';
      target = "stacks/${stack}/.env";
    };
  };
}