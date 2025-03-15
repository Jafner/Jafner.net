{ sys, stacks, pkgs, ... }: let stack = "minecraft"; in {
  home-manager.users."${sys.username}".home.file = {
    "${stack}" = {
      enable = true;
      recursive = true;
      source = ./.;
      target = "stacks/${stack}/";
    };
    "${stack}/.env" = {
      enable = true;
      text = ''
        APPDATA=${stacks.appdata}/${stack}
      '';
      target = "stacks/${stack}/.env";
    };
  };
  systemd.services."minecraft-server" = {
    requires = [ "docker.service" ];
    after = [ "docker.service" ];
    serviceConfig = {
      Restart = "no";
      User = "${sys.username}";
      Group = "docker";
      TimeoutStopSec = "120";
      WorkingDirectory = "/home/${sys.username}/stacks/${stack}";
      ExecStartPre = "docker compose down";
      ExecStart = "docker compose up";
      ExecStop = "docker compose down";
    };
  };
  systemd.timers."minecraft-server-restart" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 06:00:00";
      Unit = "minecraft-server.service";
    };
  };
  environment.systemPackages = [ pkgs.minecraft-server ];
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}