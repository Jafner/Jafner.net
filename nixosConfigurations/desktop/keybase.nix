{ pkgs
, username
, ...
}: {
  home-manager.users."${username}" = {
    services.keybase.enable = true;
    services.kbfs.enable = true;
    home.packages = with pkgs; [
      keybase
      keybase-gui
      kbfs
    ];
  };
}
