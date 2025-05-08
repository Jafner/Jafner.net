{ username
, pkgs
, ...
}: {
  home-manager.users.${username} = {
    home.packages = with pkgs; [ rofi-rbw ];
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      # theme = ''

      # '';
    };
    programs.rbw = {
      enable = true;
      settings = {
        base_url = "https://bitwarden.jafner.net";
        email = "jafner425@gmail.com";
        pinentry = pkgs.pinentry-qt;
      };
    };
    programs.zsh = {
      initContent = ''
        eval $(rbw gen-completions zsh)
        rbw unlock
        rbw sync
      '';
    };
  };
}
