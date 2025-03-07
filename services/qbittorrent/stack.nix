{ sys, stacks, ... }: let stack = "qbittorrent"; in {
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
        TORRENT_DATA=${stacks.library.torrenting}
      '';
      target = "stacks/${stack}/.env";
    };
  };
}