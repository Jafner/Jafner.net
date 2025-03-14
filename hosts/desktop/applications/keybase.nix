{ sys, pkgs, ... }: {
  home-manager.users."${sys.username}" = {
    home.packages = with pkgs; [
      keybase
    ];
    services.keybase.enable = true;
  };
}