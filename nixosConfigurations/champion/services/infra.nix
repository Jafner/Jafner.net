{username, ...}: {
  sops.secrets."stacks/autokuma.env" = {
    sopsFile = ./autokuma.secrets.env;
    mode = "0440";
    format = "dotenv";
    owner = username;
  };
  home-manager.users.${username} = {
    home.file = {
      "stacks/caddy/docker-compose.yml" = {
        enable = true;
        target = "stacks/caddy/docker-compose.yml";
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
      "stacks/vaultwarden/docker-compose.yml" = {
        enable = true;
        target = "stacks/vaultwarden/docker-compose.yml";
        text = ''
          services:
            vaultwarden:
              image: vaultwarden/server:latest
              container_name: vaultwarden
              restart: unless-stopped
              environment:
                DOMAIN: "https://bitwarden.jafner.net"
              volumes:
                - /appdata/vaultwarden/:/data/
              networks:
                - caddy
              labels:
                caddy: bitwarden.jafner.net
                caddy.reverse_proxy: "{{upstreams 80}}"
          networks:
            caddy:
              external: true
        '';
      };
    };
  };
}
