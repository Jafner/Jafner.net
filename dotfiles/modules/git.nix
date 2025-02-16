{ git, ... }: {
  home-manager.users.${git.username}.programs.git = {
    enable = true;
    userName = "${git.realname}";
    userEmail = "${git.email}";
    extraConfig = {
      init.defaultBranch = "main";
      core.sshCommand = "ssh -i $HOME/${git.sshPrivateKey}";
      gpg.format = "openpgp";
      commit.gpgsign = true;
      tag.gpgsign = true;
      user.signingKey = "${git.signingKey}";
    };
    delta.enable = true;
    delta.options.side-by-side = true;
  };
}