{ sys, stacks, ... }: let stack = "navidrome"; in {
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
        MUSIC_DIR=${stacks.library.music}
      '';
      target = "stacks/${stack}/.env";
    };
  };
}