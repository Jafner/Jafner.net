{ username, ... }:
{
  home-manager.users.${username}.programs.git = {
    enable = true;
    userName = "Joey Hafner";
    userEmail = "joey@jafner.net";
    extraConfig = {
      init.defaultBranch = "main";
      core.sshCommand = "ssh -i $HOME/.ssh/joey.desktop@jafner.net";
      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;
      user.signingKey = "/home/${username}/.ssh/joey.desktop@jafner.net.pub";
    };
    delta.enable = true;
    delta.options.side-by-side = true;
  };
}
