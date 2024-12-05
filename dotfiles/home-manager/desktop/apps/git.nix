{ pkgs, vars, ... }: {
  home.packages = with pkgs; [ git ];
  programs.git = {
    enable = true;
    userName = "${vars.user.realname}";
    userEmail = "${vars.user.email}";
    extraConfig = {
      core.sshCommand = "ssh -i /home/${vars.user.username}/.ssh/main_id_ed25519";
    };
    delta.enable = true;
    delta.options = {
      side-by-side = true;
    };
  };
}
