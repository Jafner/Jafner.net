{ username, pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/docker";
    logDriver = "local";
    rootless.enable = false;
    rootless.setSocketVariable = true;
  };
  users.users.${username}.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.docker-compose ];
  sops.secrets."autokuma" = {
    sopsFile = builtins.toFile "autokuma" ''
      AUTOKUMA__KUMA__URL=ENC[AES256_GCM,data:pzdNkA8aCx//wmWrfFx6q9v+ecwoKsA=,iv:0dC1my8vYoxFir1Xq6ZdFEF1A3ku19h3tPdIu/X9H2g=,tag:9H7+wht4RAPpQ5XNsFCZFA==,type:str]
      AUTOKUMA__KUMA__USERNAME=ENC[AES256_GCM,data:JpPsI2o/,iv:pqVCZ8L9407hCM29UDXJ4aVjG3vzZfQyq6IG8z5JGd4=,tag:IK6J+obG+eDcvs3KXHedCA==,type:str]
      AUTOKUMA__KUMA__PASSWORD=ENC[AES256_GCM,data:JxsxaES6cjOrpUMmAp0LiFllwDRxgm7zE9RoMq6ZK07VrkE3V5id1RbfEUGi6yS/1tAg6ADaQLdpIPmGm3yj,iv:kTa1vuWNnPezIQjuuEXcd8EspkXD2/JnRlP/aTDT5LM=,tag:vqhJ8H7fP6xwJb/yLpbz4w==,type:str]
      sops_age__list_0__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBpMjJyVmhZNklNTXl2OEZ0\nVVJrM282bElDMkF5SktIVkZHaXJQOFFUT1JBCmJwV3k3Wnd4TnBJeXRmZlpYenVR\nQlNGaW14UDd6Z3I4YVNBUXBPZkVIZVEKLS0tIFdUTUdyNkxkQ254Ny81blZ6ckFj\nbWZQaXVQV0poZFRLUUp5Zm1SMFR6V2MKW8ztOA69cBCABdLP5sDWXC4h5MZGSW3a\nGiQ74kFrVKbFDO42VLgWVm2qZd1KYDRav+rOmoZLX2yhSeCf03wxgg==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_0__map_recipient=age1v5wy7epv5mm8ddf3cfv8m0e9w4s693dw7djpuytz9td8ycha5f0sv2se9n
      sops_age__list_1__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBGVlNRM0VoTzZtMGtwQ2Zv\nUUJsZnF6aE90eGxmRXJSNC9kdGJMTHp3TmlRClV0OUFad29jSXkyMUx1Q0J0Y1ZD\nNGhLZ0Q5ZlJJbXdOSlpvRysvckRYdDQKLS0tIHlNU1pNa0pHajNMcUlJQXVxQ3dy\nL2FGWW9GNDN6K0RudWVZTGpVbnp6Z1UKmLVNuc9GAiOINCPySTbx03LXh10eS13j\njgaSgaU4uymFnGyS9ekNOZZoaiMlzgAitCg1BvtXVazhb56ySYIosA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_1__map_recipient=age1zswcq6t5wl8spr3g2wpxhxukjklngcav0vw8py0jnfkqd2jm2ypq53ga00
      sops_age__list_2__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBWOSsxZk5ydVdyWVVRS1pM\nREhZU1RsdUlkYjhNUEhFRERESHQzaFVVZEJNCnFVOXpoZmpRdEpyMTY2SmFVaWdu\nQUZJTEpDSlFaWVRBMm5YM3hDcFZoVHMKLS0tIFJKWWkyM08vWDhuZGJoYzR4a2NO\ncGlFUytlM2Mxd3FHNDJ1R29oUGlJYlUKbIhAonxZb9PPoDrPBSd0a8FAA6j34tCH\nqFth2ij+B2rb9xjfrv/eefCLPEkeZd/rOdzZGRZozFGMC9TvrsR14w==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_2__map_recipient=age1nq652a3y063dy5wllucf5ww29g7sx3lt8ehhspxk6u9d28t8ndgq9q0926
      sops_age__list_3__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSB1a0NkcjIyNUpMSTN3L05W\nWmZVZDAreTZyZEdmQ3RuQWJEanNtWXdoSmdRCjlNK2YyZ2Q2d3RldVJHdmZhR0Q4\nUFNyVHRpYjVHdjl3TVFvcnlVdTR0SE0KLS0tIEY1Ynk4M2hmUkc4NmJ5bEo4bGtW\nRExGMDZzSEtMSXJoRG5jODNiWEFlWmcKStV+G40tosuURi0Dy189Y5iRvrB1/GLr\ni++7y8KIKaqxsBf53VHKIFOmbNMl/qqE0wsd8C/wLvBhvGGGtznrsA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_3__map_recipient=age1mmy5xx4nxun5fexpxdl2tjx60akc4sgktrquq8c6ggvtehcpa3ss2hh2tj
      sops_age__list_4__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSAzanIrSllPajVidzZEYmMr\nWEN6aGt5V1hTc0dHNURnR3ZocWc0YjNuUDJRCjVkeGV5WlFhZk9XekZEMHdKK1dN\neVdWd0JGSHZDQUpFblE2Ynpaa29sb28KLS0tIHpRV251QkFrY1pGSVFNbERYM1FW\najN1OUQ2ZUNNcDNiUXcwRHN1d3kzcGsKPm4MQnFpl9Ndv7/2xOIfPMbXjMC28Pb0\nAYvSnXe4XEignGpukjviYdZVS8Ax+CZiD0oVy5e+pSEAYI13CXKqoA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_4__map_recipient=age10k706un6exgaym7yt8jnxz8m8n25wd9fezqxr43zkzatjleagg2s64mwt6
      sops_lastmodified=2025-05-21T01:07:04Z
      sops_mac=ENC[AES256_GCM,data:cwkEaBIaHaTwSyEhtR1XwVKj9qodt9odwo6ty4oCjdTCUUoLeoPHDRqfJomYjiREr8unUUt4bx7ZtucLKIimpEfEdu2cPflQ1whD+XMtF7CO2FK+H0Iv242jgxSehpecUng/rRJWZ7ezm0VN8NrkkXqyjArX1n8/4O4xIYW8AoE=,iv:vaAw0p/6cYBr51OB8+V3O1DOg2un+ExVP/oVrjqctec=,tag:Vy6Kcbo/ZEobKo9dDctoFw==,type:str]
      sops_unencrypted_suffix=_unencrypted
      sops_version=3.10.2
    '';
    mode = "0440";
    format = "dotenv";
    owner = username;
  };
  home-manager.users.${username} = {
    home.file = {
      "compose.yml" = {
        enable = true;
        target = "compose.yml";
        text = ''
          include:
            - caddy-docker-compose.yml
            - dockge-docker-compose.yml
            - whatsupdocke-docker-compose.yml
            - kuma-docker-compose.yml
            - forwardauth-docker-compose.yml
        '';
      };
      "caddy-docker-compose.yml" = {
        enable = true;
        target = "caddy-docker-compose.yml";
        text = ''
          name: caddy
          services:
            caddy:
              container_name: caddy
              environment:
                CADDY_INGRESS_NETWORKS: caddy
              image: lucaslorentz/caddy-docker-proxy:ci-alpine
              labels:
                caddy_0.email: joey@jafner.net
              networks:
                caddy: null
              ports:
                - mode: ingress
                  target: 80
                  published: "80"
                  protocol: tcp
                - mode: ingress
                  target: 443
                  published: "443"
                  protocol: tcp
              restart: unless-stopped
              volumes:
                - type: bind
                  source: /var/run/docker.sock
                  target: /var/run/docker.sock
                  bind:
                    create_host_path: true
                - type: bind
                  source: /appdata/caddy/data
                  target: /data
                  bind:
                    create_host_path: true
          networks:
            caddy:
              name: caddy
        '';
      };
      "dockge-docker-compose.yml" = {
        enable = true;
        target = "dockge-docker-compose.yml";
        text = ''
          name: dockge
          services:
            dockge:
              container_name: dockge
              environment:
                DOCKGE_STACKS_DIR: /appdata/dockge/stacks
              image: louislam/dockge:latest
              labels:
                caddy: dockge.jafner.net
                caddy.reverse_proxy: '{{upstreams 5001}}'
              networks:
                caddy: null
              restart: unless-stopped
              volumes:
                - type: bind
                  source: /var/run/docker.sock
                  target: /var/run/docker.sock
                  bind:
                    create_host_path: true
                - type: bind
                  source: /appdata/dockge/data
                  target: /app/data
                  bind:
                    create_host_path: true
                - type: bind
                  source: /appdata/dockge/stacks
                  target: /appdata/dockge/stacks
                  bind:
                    create_host_path: true
          networks:
            caddy:
              name: caddy
              external: true
        '';
      };
      "whatsupdocker-docker-compose.yml" = {
        enable = true;
        target = "whatsupdocker-docker-compose.yml";
        text = ''
          services:
            whatsupdocker:
              image: getwud/wud
              container_name: wud
              networks:
                - caddy
              volumes:
                - /var/run/docker.sock:/var/run/docker.sock
              labels:
                caddy: wud.jafner.net
                caddy.reverse_proxy: "{{upstreams 3000}}"
          networks:
            caddy:
              external: true
          x-dockge:
            urls:
              - https://wud.jafner.net
        '';
      };
      "kuma-docker-compose.yml" = {
        enable = true;
        target = "kuma-docker-compose.yml";
        text = ''
          services:
            autokuma:
              image: ghcr.io/bigboot/autokuma:latest
              container_name: autokuma
              restart: unless-stopped
              networks:
                - kuma
              volumes:
                - /var/run/docker.sock:/var/run/docker.sock
                - /appdata/autokuma/data:/data
              env_file:
                - path: /run/secrets/stacks/autokuma.env
            uptime-kuma:
              image: louislam/uptime-kuma:1
              container_name: uptimekuma
              restart: unless-stopped
              volumes:
                - /appdata/uptimekuma/data:/app/data
                - /var/run/docker.sock:/var/run/docker.sock
              networks:
                - caddy
                - kuma
              labels:
                caddy: uptime.jafner.net
                caddy.reverse_proxy: "{{upstreams 3001}}"
                homepage.name: Uptime Kuma
                homepage.group: Admin
                homepage.icon: sh-uptime-kuma
                homepage.href: https://uptime.jafner.net
                homepage.description: Simple service monitor.
          networks:
            kuma: null
            caddy:
              external: true
          x-dockge:
            urls:
              - https://uptime.jafner.net
        '';
      };
      "forwardauth-docker-compose.yml" = {
        enable = true;
        target = "forwardauth-docker-compose.yml";
        text = ''
          services:
            forwardauth:
              image: mesosphere/traefik-forward-auth:v3.2.1
              container_name: forwardauth
              restart: unless-stopped
              networks:
                - caddy
              env_file:
                - .env
              labels:
                caddy: auth.jafner.net
                caddy.reverse_proxy: "{{upstreams 4181}}"
            nginx:
              image: nginx:latest
              container_name: nginx
              restart: unless-stopped
              networks:
                - caddy
              labels:
                caddy: nginx.jafner.net
                caddy.forward_auth: forwardauth:4181
                caddy.forward_auth.uri: /_oauth
                caddy.forward_auth.copy_headers: X-Forwarded-User
                caddy.reverse_proxy: "{{upstreams 80}}"
          networks:
            caddy:
              external: true
          x-dockge:
            urls:
              - https://nginx.jafner.net
        '';
      };
    };
  };
  systemd.services."rclone-mount" = {
    script = ''
      #! /usr/bin/env bash
      rmount() {
        SOURCE="$1"
        DEST="''$''\{2:-$(echo $SOURCE | sed 's/:/\//' | sed 's/^/\/mnt\//')}"
        if ! [ -d $DEST ]; then sudo mkdir -p "$DEST"; sudo chown -R ${username}:users "$DEST"; fi
        rclone \
          --no-check-certificate \
          --config /home/${username}/.config/rclone/rclone.conf \
          mount \
          --daemon \
          "$SOURCE" \
          "$DEST"
      }
    '';
    serviceConfig = {
      User = "${username}";
    };
  };
}
