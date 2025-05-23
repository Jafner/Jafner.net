{ username, ... }:
{
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
      "stacks/dockge/docker-compose.yml" = {
        enable = true;
        target = "stacks/dockge/docker-compose.yml";
        text = ''
          name: dockge
          services:
            dockge:
              container_name: dockge
              environment:
                DOCKGE_STACKS_DIR: /appdata/dockge/stacks
              image: louislam/dockge:latest
              labels:
                caddy: dockge.jafner.dev
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
      "stacks/whatsupdocker/docker-compose.yml" = {
        enable = true;
        target = "stacks/whatsupdocker/docker-compose.yml";
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
                caddy: wud.jafner.dev
                caddy.reverse_proxy: "{{upstreams 3000}}"
          networks:
            caddy:
              external: true
          x-dockge:
            urls:
              - https://wud.jafner.dev
        '';
      };
      "stacks/kuma/docker-compose.yml" = {
        enable = true;
        target = "stacks/kuma/docker-compose.yml";
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
                caddy: uptime.jafner.dev
                caddy.reverse_proxy: "{{upstreams 3001}}"
                homepage.name: Uptime Kuma
                homepage.group: Admin
                homepage.icon: sh-uptime-kuma
                homepage.href: https://uptime.jafner.dev
                homepage.description: Simple service monitor.
          networks:
            kuma: null
            caddy:
              external: true
          x-dockge:
            urls:
              - https://uptime.jafner.dev
        '';
      };
      "stacks/forwardauth/docker-compose.yml" = {
        enable = true;
        target = "stacks/forwardauth/docker-compose.yml";
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
                caddy: auth.jafner.dev
                caddy.reverse_proxy: "{{upstreams 4181}}"
            nginx:
              image: nginx:latest
              container_name: nginx
              restart: unless-stopped
              networks:
                - caddy
              labels:
                caddy: nginx.jafner.dev
                caddy.forward_auth: forwardauth:4181
                caddy.forward_auth.uri: /_oauth
                caddy.forward_auth.copy_headers: X-Forwarded-User
                caddy.reverse_proxy: "{{upstreams 80}}"
          networks:
            caddy:
              external: true
          x-dockge:
            urls:
              - https://nginx.jafner.dev
        '';
      };
    };
  };
}
