{ pkgs, username, systemKey, ... }: {
  home-manager.users.${username}.programs.git = {
    enable = true;
    userName = "Joey Hafner";
    userEmail = "joey@jafner.net";
    extraConfig = {
      init.defaultBranch = "main";
      core.sshCommand = "ssh -i $HOME/${systemKey}";
      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;
      user.signingKey = "/home/${username}/${systemKey}.pub";
    };
    delta.enable = true;
    delta.options.side-by-side = true;
  };
}
