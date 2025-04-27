{ username, pkgs, ... }: {
  home-manager.users.${username} = {
    programs.rbw = {
      enable = true;
      settings = {
        base_url = "https://bitwarden.jafner.net";
        email = "jafner425@gmail.com";
        pinentry = pkgs.pinentry-all;
      };
    };
    programs.zsh.initContent = ''
      source <(rbw gen-completions zsh)
    '';
  };
}
