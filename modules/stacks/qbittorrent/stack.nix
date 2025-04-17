{ lib, config, ... }: with lib; let stack = "qbittorrent"; in let cfg = config.stacks.${stack}; in {
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
            torrents = mkOption {
              type = types.str;
              description = "Path to torrent library.";
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
    home-manager.users."${cfg.username}".home.file = {
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            qbittorrent:
              image: linuxserver/qbittorrent:latest
              container_name: qbittorrent_qbittorrent
              deploy:
                resources:
                  limits:
                    memory: 6G
              networks:
                - web
              restart: "no"
              volumes:
                - ${cfg.paths.appdata}:/config
                - ${cfg.paths.torrents}:/torrenting
              environment:
                PUID: 1000
                PGID: 1000
                TZ: America/Los_Angeles
                WEBUI_PORT: 8080
              ports:
                - 49500:49500
              labels:
                - traefik.http.routers.qbt.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.qbt.tls.certresolver=lets-encrypt
                - traefik.http.routers.qbt.middlewares=traefik-forward-auth-privileged@file
                - traefik.http.routers.qbt-api.rule=Host(`api.${cfg.domains.${stack}}`)
                - traefik.http.routers.qbt-api.tls.certresolver=lets-encrypt
                - traefik.http.routers.qbt-api.middlewares=lan-only@file
                - traefik.http.services.qbt.loadbalancer.server.port=8080

          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
