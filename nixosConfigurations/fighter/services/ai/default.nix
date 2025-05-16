{ pkgs, username, ... }:
let
  stack = "ai";
in
{
  # sops.secrets."restic/${stack}" = {
  #   sopsFile = ./restic_${stack}.token;
  #   mode = "0440";
  #   format = "binary";
  #   owner = username;
  # };
  # services.restic.backups.${stack} = {
  #   rcloneConfigFile = "/home/${username}/.config/rclone/rclone.conf";
  #   repository = "rclone:r2:fighter/${stack}";
  #   initialize = true;
  #   passwordFile = "/run/secrets/restic/${stack}";
  #   paths = [
  #     "/appdata/${stack}"
  #   ];
  #   timerConfig = {
  #     Persistent = true;
  #     OnCalendar = "daily";
  #   };
  # };
  systemd.services."rclone-sync-${stack}" = {
    script = ''
      ${pkgs.rclone}/bin/rclone sync /appdata/${stack} r2:fighter/${stack}
    '';
    serviceConfig = {
      User = "${username}";
    };
    startAt = [ "*-*-* 05:00:00" ];
  };
  home-manager.users."${username}" = {
    home.file = {
      "${stack}" = {
        enable = true;
        recursive = true;
        source = ./.;
        target = "stacks/${stack}/";
      };
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          name: "ai"
          services:
            sillytavern:
              container_name: ai_sillytavern
              image: ghcr.io/sillytavern/sillytavern:1.12.2
              networks:
                - web
              privileged: false
              volumes:
                - /appdata/${stack}/config:/home/node/app/config
                - /appdata/${stack}/data:/home/node/app/data
                - /appdata/${stack}/plugins:/home/node/app/plugins
              environment:
                TZ: America/Los_Angeles
              labels:
                - traefik.http.routers.sillytavern.rule=Host(`sillytavern.jafner.net`)
                - traefik.http.routers.sillytavern.tls.certresolver=lets-encrypt
                - traefik.http.routers.sillytavern.middlewares=traefik-forward-auth-privileged@file

          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
