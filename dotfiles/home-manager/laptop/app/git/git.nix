{ vars, ... }:
{
  ## Git
  programs.git = {
    enable = true;
    userName = "${vars.user.realname}";
    userEmail = "${vars.user.email}";
    extraConfig = { 
      core.sshCommand = "ssh -i /home/joey/.ssh/${vars.user.username}@${vars.laptop.hostname}"; 
    };
    delta.enable = true;
    delta.options = {
      side-by-side = true;
    };
  };
}
