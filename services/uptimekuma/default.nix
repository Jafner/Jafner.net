{username, ...}: let
  service = "uptimekuma";
in {
  sops.secrets."autokuma" = {
    sopsFile = builtins.toFile "autokuma" ''
      AUTOKUMA__KUMA__URL=ENC[AES256_GCM,data:twWkVIoF6Am0GNhHxZpRBxYBOakwhpE=,iv:5lVvpixI7OcZIfjaCtMD70XhXNkOz5hN57nXyOTlqio=,tag:Aho/k/eN4f60Vk/yflcXbQ==,type:str]
      AUTOKUMA__KUMA__USERNAME=ENC[AES256_GCM,data:6hCW3Tww,iv:DMgt/us3nMVgW4l87tzCLGfcuVRTNliJRXIMRfSNoL4=,tag:JZ4ggQlh3HgM+WFHoxMESA==,type:str]
      AUTOKUMA__KUMA__PASSWORD=ENC[AES256_GCM,data:uf+C3REEij7jV26HmQ3qoOdf+CZdMpRsxq1Ral899Rs=,iv:jm/gkerQhUb1r7XRgNzYfOdi0/WD+e1LjG8zi2FDLxU=,tag:AK8p00Zc0J4j2V+ZiYasyw==,type:str]
      sops_age__list_0__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBYZG1jSUxMcElTQlZ1dDVO\nMDJzRGF2ZlF2TVNBb0NmWnM5SzRJUzNiZFdrCjNXeFQ4enNlOCtrWGNublZKcW45\nWkNjdU83Unp6a3hjRjJhNEhDeXJPdWsKLS0tIDY0dmpmUXhJZURVSlpMRkVLcThx\nN3o3dEFTVGMxTmpWVEZualVucUdPbUEKNPmzudYqqKArvKlJFSBXCkXvIofAqEX2\nJrv35bEABZbw4U89tbt4fQ5sxX7PuELqrvvxvEiK1VdxPSMERQbHlA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_0__map_recipient=age1v5wy7epv5mm8ddf3cfv8m0e9w4s693dw7djpuytz9td8ycha5f0sv2se9n
      sops_age__list_1__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSB2cGVVanpJeTA2WVIzUjNC\nbDlxR0dYdi9yUWpyYzRCeHhTWlB1QUlLcUUwCm9WbEdlRFdnUzA2c25vL1g1d1Ev\nYjBWTGYybDMyR0M1MU85aXdpNGFKUTQKLS0tIHlvQkpIcTZWSXFTQktZL3NlRVVl\nam44UnEwb3UvUDhqYjR3Smg2L3RPVW8KvRR78pkKYhAJciw2iDfiIK3FdwHik+pW\nboSAJLJpoyrMISPp6ATgWFju2Z+fEsQxA8azA2pZyrvr7V4XoT9I5Q==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_1__map_recipient=age1zswcq6t5wl8spr3g2wpxhxukjklngcav0vw8py0jnfkqd2jm2ypq53ga00
      sops_age__list_2__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBRVng4emRMTE9KUFF1MlVr\nZE1Qa2lPRU50dTBnVG54YURRZzFWdEpONjJVClNUSjNlWG1ZS0VTMkxZSXZ2SzY2\nNlhQanpTbEpadGVQRk13VDFyTGduNjgKLS0tIHV5bk0vc25lRXZmY0p1SVJ5VEVB\nZnlvSXAvOHRuWVAwU3RXVnEvbk40M0EKckvaHttFEfKQWj2upGVIFFA/5TlOGlGG\nIuhnrAdJqoP/yy7890jggp/SQ2Rwh61tMi2JEHU2eD6UOyd4N4DcjA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_2__map_recipient=age1nq652a3y063dy5wllucf5ww29g7sx3lt8ehhspxk6u9d28t8ndgq9q0926
      sops_age__list_3__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBPVXQ4ZXJHYUFHQVNoRE5h\nZUJLMkJ2bmRpbjA5aWM4K3Y2VWZSUXZIZlJnCkpoeFFMb2g4amVGYlBSZXN6Ykdy\ndWdiYlpla0JLa1o0elVoNWpTeHROZ1UKLS0tIDFjd0NWdThaY1k2THptVTVNQmFM\nMTZDNGZIa3o0eDJUQzg0NW5GZGJseFkKnNxBglv9JEDrYXIxJqJWbaJ5Y3sMLPLN\nOAZHdJ0rc6ycfusXtitswYq6jktHCBtD4DjGqe5lyzX1ycojzGKiYA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_3__map_recipient=age1mmy5xx4nxun5fexpxdl2tjx60akc4sgktrquq8c6ggvtehcpa3ss2hh2tj
      sops_age__list_4__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBlSVhwY3AzNllKeVErVTlt\ncnV3QklvclBneUxmZWlXOUpRakFIOHRhVnk0ClF3cTV2YVNPbk5tTm1QL1dvUVRF\nd1hRTUc1YTdWbFR6Z3VMYXJLbmVMTEEKLS0tIFBLUHFmZ2puK3ZXQ3V0LzNaSjQz\nVjBkUG43dDZjQTdOZnhpN3h0ZU5XWW8K8PRm75ZUWgsAaHqoAU7uuPbq4WeX5RDZ\n219JrUmIkBI8rQHXEwQD0mLBrqUJQYz2U0GkchzFGiF1j5eLTHaT0Q==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_4__map_recipient=age10k706un6exgaym7yt8jnxz8m8n25wd9fezqxr43zkzatjleagg2s64mwt6
      sops_lastmodified=2025-06-05T19:22:01Z
      sops_mac=ENC[AES256_GCM,data:eIasymMCHl1KdmP/P65TSOAn9Ro+yUFEyU2U0OTJLarINV/rFTNP75LVmaI7wILMCt3Cgw2uNMthgPv3jnaSvwH85ZRWrMHZH+G42QppfDc0qPMw1mf7SsK3W103S6QMpvV7TygB6gsfzWf5p9z4u/A7xV/C+v9q5qhHfKD3i6I=,iv:byMRR3ybPADVWBW2XBOn7HG+EC8So904+6fYcpr2pNg=,tag:h/F2cfHo6TLkBpTQ3U4BZQ==,type:str]
      sops_unencrypted_suffix=_unencrypted
      sops_version=3.10.2
    '';
    mode = "0440";
    format = "dotenv";
    owner = username;
  };
  home-manager.users.${username} = {
    home.file."${service}" = {
      enable = true;
      target = "stacks-nix/${service}/compose.yml";
      text = ''
        name: ${service}
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
              - path: /run/secrets/autokuma
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
          kuma:
            name: kuma
          caddy:
            name: caddy
            external: true
        x-dockge:
          urls:
            - https://uptime.jafner.net
      '';
    };
  };
}
