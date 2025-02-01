{ sys, ... }: let stack = "plex"; in {
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
        MOVIES_DIR=${sys.dataDirs.library.movies}
        SHOWS_DIR=${sys.dataDirs.library.shows}
        MUSIC_DIR=${sys.dataDirs.library.music}
      '';
      target = "stacks/${stack}/.env";
    };
  };
}