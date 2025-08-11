{username, ...}: let
  service = "plex";
in {
  home-manager.users.${username} = {
    home.file."${service}" = {
      enable = true;
      target = "stacks-nix/${service}/compose.yml";
      text = ''
        name: plex
        services:
          plex:
            image: linuxserver/plex:latest
            container_name: plex
            restart: "no"
            networks:
              - caddy
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
              PUID: 1000
              PGID: 100
              TZ: America/Los_Angeles
              VERSION: latest
              ADVERTISE_IP: "https://plex.jafner.net:443"
              PLEX_CLAIM: ''$''\{PLEX_CLAIM}
              volumes:
                - /appdata/plex/plex:/config
                - movies:/movies
                - shows:/shows
            labels:
              caddy: plex.jafner.net
              caddy.reverse_proxy: "{{upstreams 32400}}"
              kuma.plex.http.name: plex
              kuma.plex.http.url: https://plex.jafner.net/web

          ombi:
            image: ghcr.io/linuxserver/ombi:latest
            container_name: ombi
            restart: no
            networks:
              - caddy
            environment:
              PUID: 1000
              PGID: 100
              TZ: America/Los_Angeles
            volumes:
              - /appdata/plex/ombi:/config
            labels:
              caddy: ombi.jafner.net
              caddy.reverse_proxy: "{{upstreams 3579}}"
              kuma.ombi.http.name: ombi
              kuma.ombi.http.url: https://ombi.jafner.net
        volumes:
          movies:
            name: movies
            driver: rclone
            driver_opts:
              remote: paladin:Movies
              allow_other: "true"
              vfs_cache_mode: full
              poll_interval: 0
          shows:
            name: shows
            driver: rclone
            driver_opts:
              remote: paladin:Shows
              allow_other: "true"
              vfs_cache_mode: full
              poll_interval: 0
        networks:
          caddy:
            name: caddy
            external: true
      '';
    };
  };
}
