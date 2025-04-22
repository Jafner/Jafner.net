{ username, ... }:
  let
    stack = "autopirate";
  in {
  home-manager.users."${username}".home.file = {
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
              - "/mnt/music:/music"
              - "/appdata/autopirate/lidarr_config:/config"
              - "/appdata/autopirate/torrenting/NZB:/downloads"
            labels:
              - traefik.http.routers.lidarr.rule=Host(`lidarr.jafner.net`)
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
              - "/mnt/movies:/movies"
              - "/appdata/autopirate/radarr_config:/config"
              - "/appdata/autopirate/torrenting/NZB:/downloads"
            labels:
              - traefik.http.routers.radarr.rule=Host(`radarr.jafner.net`)
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
              - "/mnt/shows:/shows"
              - "/appdata/autopirate/sonarr_config:/config"
              - "/appdata/autopirate/torrenting/NZB:/downloads"
            labels:
              - traefik.http.routers.sonarr.rule=Host(`sonarr.jafner.net`)
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
              - "/appdata/autopirate/nzbhydra2_config:/config"
              - "/appdata/autopirate/torrenting/NZB:/downloads"
            labels:
              - traefik.http.routers.nzbhydra2.rule=Host(`nzbhydra.jafner.net`)
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
              - "/appdata/autopirate/sabnzbd_config:/config"
              - "/mnt/movies:/movies"
              - "/mnt/shows:/shows"
              - "/mnt/music:/music"
              - "/appdata/autopirate/torrenting/NZB:/downloads"
              - "/appdata/autopirate/torrenting/NZB_incomplete:/incomplete-downloads"
            labels:
              - traefik.http.routers.sabnzbd.rule=Host(`sabnzbd.jafner.net`)
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
}
