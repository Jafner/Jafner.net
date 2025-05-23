{ username, ... }:
let
  stack = "vaultwarden";
in
{
  sops.secrets."${stack}" = {
    sopsFile = ./vaultwarden.secrets.env;
    key = "";
    mode = "0440";
    owner = username;
  };
  home-manager.users."${username}".home.file = {
    "${stack}/docker-compose.yml" = {
      enable = true;
      text = ''
        services:
          ${stack}:
            image: vaultwarden/server:1.33.2
            container_name: ${stack}_vaultwarden
            restart: "no"
            env_file:
              - path: /run/secrets/vaultwarden
                required: true
            environment:
              DOMAIN: "bitwarden.jafner.net"
              SIGNUPS_ALLOWED: "true"
            volumes:
              - /appdata/${stack}/data:/data
            networks:
              - web
            labels:
              - traefik.http.routers.${stack}.middlewares=securityheaders@file
              - traefik.http.routers.${stack}.rule=Host(`bitwarden.jafner.net`)
              - traefik.http.routers.${stack}.tls.certresolver=lets-encrypt
              - traefik.http.routers.${stack}.tls.options=tls12@file
        networks:
          web:
            external: true
      '';
      target = "stacks/${stack}/docker-compose.yml";
    };
  };
}
