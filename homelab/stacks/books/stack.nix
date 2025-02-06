{ sys, ... }: let stack = "books"; in {
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
        EBOOKS_LIBRARY=${sys.dataDirs.library.books}/ebooks
        AUDIOBOOKS_LIBRARY=${sys.dataDirs.library.books}/audiobooks
        NZB_COMPLETED=${sys.dataDirs.appdata}/torrenting/NZB
        NZB_INCOMPLETE=${sys.dataDirs.appdata}/torrenting/NZB_incomplete
        LIBRARY_DIR=${sys.dataDirs.library.books}/Calibre
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