{ sys, stacks, ... }: let stack = "plex"; in {
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
        MOVIES_DIR=${stacks.library.movies}
        SHOWS_DIR=${stacks.library.shows}
        MUSIC_DIR=${stacks.library.music}
      '';
      target = "stacks/${stack}/.env";
    };
  };
}