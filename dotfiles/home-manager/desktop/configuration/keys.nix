{ pkgs, vars, ... }: {
  home.packages = with pkgs; [
    ssh-to-age
  ];
  home.file."profiles" = {
    target = ".ssh/profiles";
    text = ''
    admin@192.168.1.31
    admin@192.168.1.32
    admin@192.168.1.33
    admin@192.168.1.10
    admin@192.168.1.11
    admin@192.168.1.12
    vyos@192.168.1.1
    admin@192.168.1.23
    admin@143.110.151.123
    '';
  };
  home.file."config" = {
    target = ".ssh/config";
    text = ''
      Host *
        ForwardAgent yes
        IdentityFile ~/.ssh/${vars.desktop.sshKey}
  '';
  };
  home.file."authorized_keys" = {
    target = ".ssh/authorized_keys";
    text = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9guFiLtbnUn93C3fBggGFyPqR3/5pPKrVTtuGL/dcP joey@pixel
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFzxkV2KZDEUKddI2sbgpQkYFazRSmt/XfzVhcHHDGso joey@joey-laptop
    '';
  };
}