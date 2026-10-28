{username, ...}: {
  virtualisation.docker.enable = true;
  sops.secrets = {
    "stacks/vaultwarden.env" = {
      sopsFile = ./vaultwarden.secrets.env;
      mode = "0440";
      format = "dotenv";
      owner = username;
    };
    "cloudflare/r2/access_key_id" = {
      sopsFile = ../../../secrets/cloudflare.secrets.yml;
      mode = "0440";
      owner = username;
    };
    "cloudflare/r2/secret_access_key" = {
      sopsFile = ../../../secrets/cloudflare.secrets.yml;
      mode = "0440";
      owner = username;
    };
  };
  systemd.services."rclone-sync-appdata" = {
    script = ''
      ${pkgs.rclone}/bin/rclone sync /appdata/vaultwarden r2:champion/vaultwarden/
    '';
    serviceConfig = {
      User = "${username}";
    };
    startAt = ["*-*-* 05:00:00"];
  };
  home-manager.users.${username} = {
    programs.rclone = {
      enable = true;
      remotes = {
        r2 = {
          config = {
            type = "s3";
            provider = "Cloudflare";
            env_auth = "true";
            region = "auto";
            endpoint = "https://9c3bc49e4d283320f5df4fc2e8ed9acc.r2.cloudflarestorage.com";
          };
          secrets = {
            access_key_id = "/run/secrets/cloudflare/r2/access_key_id";
            secret_access_key = "/run/secrets/cloudflare/r2/secret_access_key";
          };
        };
      };
    };
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
              env_file:
                - path: /run/secrets/stacks/vaultwarden.env
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
