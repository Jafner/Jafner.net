{ username, ... }: {
  services.tailscale.enable = true;
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/docker";
    logDriver = "local";
    rootless.enable = false;
    rootless.setSocketVariable = true;
  };
  sops.secrets."whatsupdocker.env" = {
    sopsFile = ../../secrets/jafner.net.secrets.yml;
    key = ''["keycloak"]["wud.jafner.dev"]'';
    mode = "0440";
    format = "dotenv";
    owner = username;
  };
  sops.secrets."autokuma.env" = {
    sopsFile = ../../secrets/jafner.dev.secrets.yml;
    key = ''["uptime-kuma"]["autokuma"]'';
    mode = "0440";
    format = "dotenv";
    owner = username;
  };
  sops.secrets."forwardauth.env" = {
    sopsFile = ../../secrets/jafner.net.secrets.yml;
    key = ''["keycloak"]["auth.jafner.dev"]'';
    mode = "0440";
    format = "dotenv";
    owner = username;
  };

  home-manager.users.${username} = {
    home.file = {
      "compose.yml" = {
        enable = true;
        target = "compose.yml";
        text = let baseDomain = "jafner.net"; in ''
          services:
            caddy:
              image: lucaslorentz/caddy-docker-proxy:ci-alpine
              container_name: caddy
              restart: unless-stopped
              networks:
                - caddy
              ports:
                - 80:80
                - 443:443
              volumes:
                - /var/run/docker.sock:/var/run/docker.sock
                - /appdata/caddy/data:/data
              environment:
                - CADDY_INGRESS_NETWORKS=caddy
              labels:
                caddy_0.email: "joey@jafner.net"
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
                - path: /run/secrets/autokuma.env
                  required: true
              environment:
                AUTOKUMA__KUMA__URL: http://uptime-kuma:3001
                AUTOKUMA__KUMA__USERNAME: Jafner
                # Declared in autokuma.env; should trigger warning on `compose up` if empty:
                AUTOKUMA__KUMA__PASSWORD: $AUTOKUMA__KUMA__PASSWORD
            dockge:
              image: louislam/dockge:latest
              container_name: dockge
              restart: unless-stopped
              networks:
                - caddy
              volumes:
                - /var/run/docker.sock:/var/run/docker.sock
                - /appdata/dockge/data:/app/data
                - /appdata/dockge/stacks:/appdata/dockge/stacks
              environment:
                - DOCKGE_STACKS_DIR=/appdata/dockge/stacks
              labels:
                caddy: dockge.${baseDomain}
                caddy.reverse_proxy: "{{upstreams 5001}}"
            whatsupdocker:
              image: getwud/wud
              container_name: wud
              networks:
                - caddy
              volumes:
                - /var/run/docker.sock:/var/run/docker.sock
              env_file:
                - path: /run/secrets/whatsupdocker.env
                  required: true
              environment:
                WUD_AUTH_OIDC_KEYCLOAK_CLIENTID: wud.${baseDomain}
                WUD_AUTH_OIDC_KEYCLOAK_DISCOVERY: https://keycloak.jafner.net/realms/Jafner.net/.well-known/openid-configuration
                WUD_AUTH_OIDC_KEYCLOAK_REDIRECT: true
                # Declared in whatsupdocker.env; should trigger warning on `compose up` if empty:
                WUD_AUTH_OIDC_KEYCLOAK_CLIENTSECRET: $WUD_AUTH_OIDC_KEYCLOAK_CLIENTSECRET
              labels:
                caddy: wud.${baseDomain}
                caddy.reverse_proxy: "{{upstreams 3000}}"
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
                caddy: uptime.${baseDomain}
                caddy.reverse_proxy: "{{upstreams 3001}}"
            socks5proxy:
              image: serjs/go-socks5-proxy:latest
              container_name: socks5proxy
              restart: unless-stopped
              networks:
                - caddy
              ports:
                - 11080:1080/tcp
              labels:
                caddy: proxy.${baseDomain}
                caddy.respond: / "HTTP not supported. Use socks5 on port 11080." 301
            forwardauth:
              image: mesosphere/traefik-forward-auth:v3.2.1
              container_name: forwardauth
              restart: unless-stopped
              networks:
                - caddy
              env_file:
                - .env
              labels:
                caddy: auth.${baseDomain}
                caddy.reverse_proxy: "{{upstreams 4181}}"
            nginx:
              image: nginx:latest
              container_name: nginx
              restart: unless-stopped
              networks:
                - caddy
              labels:
                caddy: nginx.${baseDomain}
                caddy.forward_auth: forwardauth:4181
                caddy.forward_auth.uri: /_oauth
                caddy.forward_auth.copy_headers: X-Forwarded-User
                caddy.reverse_proxy: "{{upstreams 80}}"
            whoami:
              image: traefik/whoami
              container_name: whoami
              networks:
                - caddy
              labels:
                caddy: whoami.${baseDomain}
                caddy.reverse_proxy: "{{upstreams 80}}"

          networks:
            caddy:
              name: caddy
            kuma: null
        '';
      };
    };
  };
}
