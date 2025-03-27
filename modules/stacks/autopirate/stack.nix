{ pkgs, config, ... }: let stack = "autopirate"; in let cfg = config.modules.stacks.${stack}; in {
  options = with pkgs.lib; {
    modules.stacks.${stack} = {
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
            movies = mkOption {
              type = types.str;
              description = "Path to movie library.";
            };
            shows = mkOption {
              type = types.str;
              description = "Path to shows library.";
            };
            music = mkOption {
              type = types.str;
              description = "Path to music library.";
            };
            nzb = mkOption {
              type = types.str;
              description = "Path to which completed NZB downloads should be moved.";
              default = "${cfg.paths.appdata}/torrenting/NZB";
            };
            nzbIncomplete = mkOption {
              type = types.str;
              description = "Path in which incomplete NZB downloads should be kept.";
              default = "${cfg.paths.appdata}/torrenting/NZB_incomplete";
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
            lidarr = mkOption {
              type = types.str;
              default = "lidarr.${cfg.domains.base}";
              description = "Subdomain for lidarr.";
              example = "music.autopirate.\${cfg.domains.base}";
            };
            radarr = mkOption {
              type = types.str;
              default = "radarr.${cfg.domains.base}";
              description = "Subdomain for radarr.";
              example = "movies.autopirate.\${cfg.domains.base}";
            };
            sonarr = mkOption {
              type = types.str;
              default = "sonarr.${cfg.domains.base}";
              description = "Subdomain for sonarr.";
              example = "shows.autopirate.\${cfg.domains.base}";
            };
            nzbhydra = mkOption {
              type = types.str;
              default = "nzbhydra.${cfg.domains.base}";
              description = "Subdomain for nzbhydra.";
              example = "nzbhydra.autopirate.\${cfg.domains.base}";
            };
            sabnzbd = mkOption {
              type = types.str;
              default = "sabnzbd.${cfg.domains.base}";
              description = "Subdomain for sabnzbd.";
              example = "sabnzbd.autopirate.\${cfg.domains.base}";
            };
          };
        };
      };
    };
  };
  config =  pkgs.lib.mkIf cfg.enable  {
    home-manager.users."${cfg.username}".home.file = {
      "${stack}" = {
        enable = true;
        recursive = true;
        source = /.;
        target = "stacks/${stack}/";
      };
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            lidarr:
              image: linuxserver/lidarr
              container_name: autopirate_lidarr
              networks:
                - web
              environment:
                TZ: America/Los_Angeles
                PUID: 1001
                PGID: 1001
              volumes:
                - "${cfg.paths.music}:/music"
                - "${cfg.paths.appdata}/lidarr_config:/config"
                - "${cfg.paths.nzb}:/downloads"
              labels:
                - traefik.http.routers.lidarr.rule=Host(`${cfg.domains.lidarr}`)
                - traefik.http.routers.lidarr.tls.certresolver=lets-encrypt
                - traefik.http.services.lidarr.loadbalancer.server.port=8686
                - traefik.http.routers.lidarr.middlewares=lan-only@file,traefik-forward-auth-privileged@file
            radarr:
              image: linuxserver/radarr:latest
              container_name: autopirate_radarr
              networks:
                - web
              environment:
                TZ: America/Los_Angeles
                PUID: 1001
                PGID: 1001
              volumes:
                - "${cfg.paths.movies}:/movies"
                - "${cfg.paths.appdata}/radarr_config:/config"
                - "${cfg.paths.nzb}:/downloads"
              labels:
                - traefik.http.routers.radarr.rule=Host(`${cfg.domains.radarr}`)
                - traefik.http.routers.radarr.tls.certresolver=lets-encrypt
                - traefik.http.services.radarr.loadbalancer.server.port=7878
                - traefik.http.routers.radarr.middlewares=lan-only@file,traefik-forward-auth-privileged@file
            sonarr:
              image: linuxserver/sonarr:latest
              container_name: autopirate_sonarr
              networks:
                - web
              environment:
                TZ: America/Los_Angeles
                PUID: 1001
                PGID: 1001
              volumes:
                - "${cfg.paths.shows}:/shows"
                - "${cfg.paths.appdata}/sonarr_config:/config"
                - "${cfg.paths.nzb}:/downloads"
              labels:
                - traefik.http.routers.sonarr.rule=Host(`${cfg.domains.sonarr}`)
                - traefik.http.routers.sonarr.tls.certresolver=lets-encrypt
                - traefik.http.services.sonarr.loadbalancer.server.port=8989
                - traefik.http.routers.sonarr.middlewares=lan-only@file,traefik-forward-auth-privileged@file
            nzbhydra2:
              image: linuxserver/nzbhydra2:latest
              container_name: autopirate_nzbhydra2
              networks:
                - web
              environment:
                TZ: America/Los_Angeles
                PUID: 1001
                PGID: 1001
              volumes:
                - "${cfg.paths.appdata}/nzbhydra2_config:/config"
                - "${cfg.paths.nzb}:/downloads"
              labels:
                - traefik.http.routers.nzbhydra2.rule=Host(`${cfg.domains.nzbhydra}`)
                - traefik.http.routers.nzbhydra2.tls.certresolver=lets-encrypt
                - traefik.http.services.nzbhydra2.loadbalancer.server.port=5076
                - traefik.http.routers.nzbhydra2.middlewares=lan-only@file,traefik-forward-auth-privileged@file
            sabnzbd:
              image: linuxserver/sabnzbd:latest
              container_name: autopirate_sabnzbd
              networks:
                - web
              environment:
                TZ: America/Los_Angeles
                PUID: 1001
                PGID: 1001
              ports:
                - 8085:8080
              volumes:
                - "${cfg.paths.appdata}/sabnzbd_config:/config"
                - "${cfg.paths.movies}:/movies"
                - "${cfg.paths.shows}:/shows"
                - "${cfg.paths.music}:/music"
                - "${cfg.paths.nzb}:/downloads"
                - "${cfg.paths.nzbIncomplete}:/incomplete-downloads"
              labels:
                - traefik.http.routers.sabnzbd.rule=Host(`${cfg.domains.sabnzbd}`)
                - traefik.http.routers.sabnzbd.tls.certresolver=lets-encrypt
                - traefik.http.services.sabnzbd.loadbalancer.server.port=8080
                - traefik.http.routers.sabnzbd.middlewares=lan-only@file,traefik-forward-auth-privileged@file
          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
