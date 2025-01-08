{ pkgs, vars, sysVars, ... }: {
  home.packages = with pkgs; [ git ];
  programs.git = {
    enable = true;
    userName = "${vars.user.realname}";
    userEmail = "${vars.user.email}";
    extraConfig = {
      init.defaultBranch = "main";
      core.sshCommand = "ssh -i /home/${vars.user.username}/.ssh/${sysVars.sshKey}";
      gpg.format = "openpgp";
      commit.gpgsign = true;
      tag.gpgsign = true;
      user.signingKey = "${sysVars.signingKey}";
    };
    delta.enable = true;
    delta.options = {
      side-by-side = true;
    };
  };
}
