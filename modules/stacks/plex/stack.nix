{ pkgs, lib, config, username, ... }: with lib; let stack = "plex"; in let cfg = config.stacks.${stack}; in {
  options = with pkgs.lib; {
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
              default = "${stack}";
              description = "Subdomain for ${stack}.";
              example = "someservice";
            };
          };
        };
      };
    };
  };
  config = mkIf cfg.enable  {
    home-manager.users."${username}".home.file = {
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            plex:
              image: linuxserver/plex:latest
              container_name: plex_plex
              restart: "no"
              networks:
                - web
              ports:
                - 32400:32400/tcp
                - 32400:32400/udp
                - 3005:3005/tcp
                - 8324:8324/tcp
                - 32469:32469/tcp
                - 1900:1900/udp
                - 32410:32410/udp
                - 32412:32412/udp
                - 32413:32413/udp
                - 32414:32414/udp
              environment:
                PUID: 1001
                PGID: 1001
                TZ: America/Los_Angeles
                VERSION: latest
                ADVERTISE_IP: "https://${cfg.domains.${stack}}:443"
              volumes:
                - "${cfg.paths.movies}:/movies"
                - "${cfg.paths.shows}:/shows"
                - "${cfg.paths.music}:/music"
                - "${cfg.paths.appdata}/plex:/config"
              labels:
                - traefik.http.routers.plex.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.plex.tls.certresolver=lets-encrypt
                - traefik.http.services.plex.loadbalancer.server.port=32400

            ombi:
              image: ghcr.io/linuxserver/ombi:latest
              container_name: plex_ombi
              restart: "no"
              networks:
                - web
              environment:
                PUID: 1001
                PGID: 1001
                TZ: America/Los_Angeles
              volumes:
                - "${cfg.paths.appdata}/ombi:/config"
              labels:
                - traefik.http.routers.ombi.rule=Host(`${cfg.domains.ombi}`)
                - traefik.http.routers.ombi.tls.certresolver=lets-encrypt
                - traefik.http.routers.ombi.tls.options=tls12@file
                - traefik.http.routers.ombi.middlewares=securityheaders@file
                - traefik.http.services.ombi.loadbalancer.server.port=3579

          networks:
            web:
              external: true
            monitoring:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
