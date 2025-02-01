{ sys, ... }: let stack = "navidrome"; in {
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
        MUSIC_DIR=${sys.dataDirs.library.music}
      '';
      target = "stacks/${stack}/.env";
    };
  };
}