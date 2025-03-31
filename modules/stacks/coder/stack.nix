{ pkgs, lib, config, username, ... }: with lib; let stack = "coder"; in let cfg = config.stacks.${stack}; in {
  options = {
    stacks.${stack} = {
      enable = mkEnableOption "${stack}";
      secretsFiles = mkOption {
        type = types.submodule {
          options = {
            ${stack} = mkOption {
              type = types.pathInStore;
              description = "Path to a sops-nix-encrypted secrets file for keycloak.";
            };
            db = mkOption {
              type = types.pathInStore;
              description = "Path to a sops-nix-encrypted secrets file for postgres.";
            };
          };
        };
      };
      paths = mkOption {
        type = types.submodule {
          options = {
            appdata = mkOption {
              type = types.str;
              description = "Path to store persistent data for the stack.";
            };
          };
        };
      };
      domains = mkOption {
        type = types.submodule {
          options = {
            base = mkOption {
              type = types.str;
              description = "Base domain for the stack.";
              example = "mydomain.tld";
            };
            ${stack} = mkOption {
              type = types.str;
              default = "${stack}";
              description = "Subdomain for ${stack}.";
              example = "someservice";
            };
          };
        };
      };
    };
  };
  config = mkIf cfg.enable  {
    sops.secrets."${stack}" = {
      sopsFile = cfg.secretsFiles.${stack};
      key = "";
      mode = "0440";
      owner = username;
    };
    home-manager.users."${username}".home.file = {
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            coder:
              image: ghcr.io/coder/coder:latest
              container_name: coder_coder
              restart: "no"
              env_file:
                - path: /run/secrets/coder
                  required: true
              environment:
                - CODER_ACCESS_URL="https://${cfg.domains.${stack}}"
                - CODER_HTTP_ADDRESS="0.0.0.0:7080"
                - CODER_PG_CONNECTION_URL="postgresql://$PGUSERNAME:$PGPASSWORD@postgres/coder"
              networks:
                - web
                - coder
              volumes:
                - ${cfg.paths.appdata}/coder:/home/coder/.config
                - /var/run/docker.sock:/var/run/docker.sock:ro
              labels:
                - traefik.http.routers.coder.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.coder.tls.certresolver=lets-encrypt-dns01
                - traefik.http.routers.coder.tls.options=tls12@file
                - traefik.http.routers.coder.middlewares=securityheaders@file
                #- traefik.http.services.coder.loadbalancer.server.port=1234
              depends_on:
                postgres:
                  condition: service_healthy

            postgres:
              image: postgres:16
              container_name: coder_postgres
              env_file:
                - path: /run/secrets/coder
                  required: true
              networks:
                - coder
              healthcheck:
                test:
                  [
                    "CMD-SHELL",
                    "pg_isready -U ''$''\{POSTGRES_USER:-username} -d ''$''\{POSTGRES_DB:-coder}",
                  ]
                interval: 5s
                timeout: 5s
                retries: 5

          networks:
            web:
              external: true
            coder:
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
