{ sys, stacks, ... }: let stack = "autopirate"; in {
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
        BOOKS_DIR=${stacks.library.books}
        NZB_DIR=$APPDATA/torrenting/NZB
        INCOMPLETE_NZB_DIR=$APPDATA/torrenting/NZB_incomplete
        TRANSCODE_DIR=$APPDATA/tdarr
      '';
      target = "stacks/${stack}/.env";
    };
  };
}