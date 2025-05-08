{ pkgs
, lib
, config
, username
, ...
}:
with lib; let
  stack = "minecraft";
in
let
  cfg = config.stacks.${stack};
in
{
  options = {
    stacks.${stack} = {
      enable = mkEnableOption "${stack}";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
      paths = mkOption {
        type = types.submodule {
          options = {
            appdata = mkOption {
              type = types.str;
              description = "Path to store persistent data for the stack.";
            };
          };
        };
      };
      domains = mkOption {
        type = types.submodule {
          options = {
            base = mkOption {
              type = types.str;
              description = "Base domain for the stack.";
              example = "mydomain.tld";
            };
            ${stack} = mkOption {
              type = types.str;
              default = "${stack}.${cfg.domains.base}";
              description = "Domain for ${stack}.";
              example = "someservice.mydomain.tld";
            };
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
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
                - ${cfg.paths.appdata}/tnp7:/data

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
  };
}
