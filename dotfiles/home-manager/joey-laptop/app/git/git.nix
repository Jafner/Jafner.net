{ ... }:
{
  ## Git
  programs.git = {
    enable = true;
    userName = "Joey Hafner";
    userEmail = "joey@jafner.net";
    extraConfig = { 
      core.sshCommand = "ssh -i /home/joey/.ssh/joey@joey-laptop"; 
    };
    delta.enable = true;
    delta.options = {
      side-by-side = true;
    };
  };
}