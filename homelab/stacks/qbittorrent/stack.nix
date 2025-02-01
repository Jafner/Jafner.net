{ sys, ... }: let stack = "qbittorrent"; in {
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
        TORRENT_DATA=${sys.dataDirs.library.torrenting}
      '';
      target = "stacks/${stack}/.env";
    };
  };
}