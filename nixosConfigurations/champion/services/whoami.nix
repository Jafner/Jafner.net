{ pkgs, username, ... }:
let
  service = "whoami";
  defaultDomain = "jafner.dev";
in
{
  sops.secrets."cloudflare/r2/access_key_id" = {
    sopsFile = ../../../secrets/cloudflare.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."cloudflare/r2/secret_access_key" = {
    sopsFile = ../../../secrets/cloudflare.secrets.yml;
    mode = "0440";
    owner = username;
  };
  systemd.services."rclone-sync-appdata-${service}" = {
    script = ''
      ${pkgs.rclone}/bin/rclone sync /appdata/${service} r2:${service}
    '';
    serviceConfig = {
      User = "${username}";
    };
    startAt = [ "*-*-* 05:00:00" ];
  };
  home-manager.users.${username} = {
    home.file = {
      "stacks/${service}/docker-compose.yml" = {
        enable = true;
        target = "stacks/${service}/docker-compose.yml";
        text = ''
          name: ${service}
          services:
            ${service}:
              container_name: ${service}
              image: traefik/whoami:latest
              networks:
                caddy: null
              restart: unless-stopped
              volumes:
                - type: bind
                  source: /appdata/${service}/data
                  target: /data
                  bind:
                    create_host_path: true
              labels:
                caddy: ${service}.${defaultDomain}
                caddy.reverse_proxy: "{{upstreams 80}}"
                kuma.${service}.http.name: ${service}
                kuma.${service}.http.url: https://${service}.${defaultDomain}
                homepage.name: Whoami
                homepage.group: Admin
                homepage.icon: sh-dumbwhois-dark
                homepage.href: https://${service}.${defaultDomain}
                homepage.description: Tiny Go server that prints os information and HTTP request to output

          networks:
            caddy:
              name: caddy
              external: true
        '';
      };
    };
  };
}
