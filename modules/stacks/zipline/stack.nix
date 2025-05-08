{ lib
, config
, username
, ...
}:
with lib; let
  stack = "zipline";
in
let
  cfg = config.stacks.${stack};
in
{
  options = {
    stacks.${stack} = {
      enable = mkEnableOption "${stack}";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
      secretsFiles = mkOption {
        type = types.submodule {
          options = {
            zipline = mkOption {
              type = types.pathInStore;
              description = "Path to a sops-nix-encrypted secrets file for zipline.";
            };
            postgres = mkOption {
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
  config = mkIf cfg.enable {
    sops.secrets."${stack}/zipline" = {
      sopsFile = cfg.secretsFiles.zipline;
      key = "";
      mode = "0440";
      format = "binary";
      owner = username;
    };
    sops.secrets."${stack}/postgres" = {
      sopsFile = cfg.secretsFiles.postgres;
      key = "";
      mode = "0440";
      format = "binary";
      owner = username;
    };
    home-manager.users."${username}".home.file = {
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            zipline:
              image: ghcr.io/diced/zipline:latest
              container_name: zipline_zipline
              restart: unless-stopped
              networks:
                - zipline
                - web
              environment:
                TZ: America/Los_Angeles
                MFA_TOTP_ENABLED: true
                WEBSITE_SHOW_FILES_PER_USER: true
                WEBSITE_TITLE: ${cfg.domains.base}
                CORE_RETURN_HTTPS: true
                CORE_HOST: 0.0.0.0
                CORE_PORT: 3000
                CORE_LOGGER: true
                UPLOADER_ASSUME_MIMETYPES: true
                DATASOURCE_TYPE: local
                DATASOURCE_LOCAL_DIRECTORY: /uploads
                UPLOADER_ADMIN_LIMIT: 25gb
                UPLOADER_USER_LIMIT: 100mb
              env_file:
                - path: /run/secrets/zipline/zipline
                  required: true
              volumes:
                - ${cfg.paths.appdata}/zipline/uploads:/uploads
                - ${cfg.paths.appdata}/zipline/public:/public
              labels:
                - traefik.http.routers.zipline.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.zipline.tls.certresolver=lets-encrypt
                - traefik.http.routers.zipline.tls.options=tls12@file
                - traefik.http.services.zipline.loadbalancer.server.port=3000

            postgres:
              image: postgres:15
              container_name: zipline_postgres
              restart: unless-stopped
              networks:
                zipline:
                  aliases:
                    - postgres
              environment:
                POSTGRES_USER: zipline
                POSTGRES_DATABASE: zipline
              env_file:
                - path: /run/secrets/zipline/postgres
                  required: true
              volumes:
                - ${cfg.paths.appdats}/postgres:/var/lib/postgresql/data
              healthcheck:
                test: ['CMD-SHELL', 'pg_isready -U zipline']
                interval: 10s
                timeout: 5s
                retries: 5

          networks:
            web:
              external: true
            zipline:
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
