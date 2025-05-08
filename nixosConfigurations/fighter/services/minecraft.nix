{ username
, pkgs
, ...
}:
let
  stack = "minecraft";
in
{
  home-manager.users."${username}".home.file = {
    "${stack}/docker-compose.yml" = {
      enable = true;
      text = ''
        services:
          router:
            image: itzg/mc-router:latest
            container_name: ${stack}_router
            restart: "no"
            networks:
              - minecraft
            ports:
              - 25565:25565
            environment:
              DEFAULT: server:25565
          server:
            image: itzg/minecraft-server:java17
            container_name: ${stack}_server
            networks:
              - minecraft
            environment:
              EULA: "TRUE"
              TYPE: "FORGE"
              VERSION: "1.20.1"
              FORGE_VERSION: "47.3.1"
              MEMORY: 24G
              USE_AIKAR_FLAGS: true
              DIFFICULTY: hard
              ALLOW_FLIGHT: true
              LEVEL: world
            volumes:
              - /appdata/${stack}/tnp7:/data

        networks:
          minecraft:
      '';
      target = "stacks/${stack}/docker-compose.yml";
    };
  };
  systemd.services."minecraft-server" = {
    requires = [ "docker.service" ];
    after = [ "docker.service" ];
    serviceConfig = {
      Restart = "no";
      User = "${username}";
      Group = "docker";
      TimeoutStopSec = "120";
      WorkingDirectory = "/home/${username}/stacks/${stack}";
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
