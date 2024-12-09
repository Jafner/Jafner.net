{ pkgs, vars, ... }: {
  home.packages = with pkgs; [ git ];
  programs.git = {
    enable = true;
    userName = "${vars.user.realname}";
    userEmail = "${vars.user.email}";
    extraConfig = {
      init.defaultBranch = "main";
      core.sshCommand = "ssh -i /home/${vars.user.username}/.ssh/${vars.desktop.sshKey}";
      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;
      user.signingKey = "/home/${vars.user.username}/.ssh/${vars.desktop.sshKey}.pub";
    };
    delta.enable = true;
    delta.options = {
      side-by-side = true;
    };
  };
}
