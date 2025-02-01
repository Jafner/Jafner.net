{ sys, ... }: let stack = "autopirate"; in {
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
        BOOKS_DIR=${sys.dataDirs.library.books}
        NZB_DIR=$APPDATA/torrenting/NZB
        INCOMPLETE_NZB_DIR=$APPDATA/torrenting/NZB_incomplete
        TRANSCODE_DIR=$APPDATA/tdarr
      '';
      target = "stacks/${stack}/.env";
    };
  };
}