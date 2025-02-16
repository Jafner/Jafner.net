{ sys, stacks, ... }: let stack = "books"; in {
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
        EBOOKS_LIBRARY=${stacks.library.books}/ebooks
        AUDIOBOOKS_LIBRARY=${stacks.library.books}/audiobooks
        NZB_COMPLETED=${stacks.appdata}/torrenting/NZB
        NZB_INCOMPLETE=${stacks.appdata}/torrenting/NZB_incomplete
        LIBRARY_DIR=${stacks.library.books}/Calibre
      '';
      target = "stacks/${stack}/.env";
    };
  };
  sops.secrets."${stack}" = { 
    sopsFile = ./books.secrets;
    key = "";
    mode = "0440";
    owner = sys.username;
  };
}