{ pkgs
, lib
, config
, username
, ...
}:
with lib; let
  stack = "manyfold";
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
            manyfold = mkOption {
              type = types.pathInStore;
              description = "Path to a sops-nix-encrypted secrets file for manyfold.";
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
  config = pkgs.lib.mkIf cfg.enable {
    sops.secrets."${stack}/manyfold" = {
      sopsFile = cfg.secretsFiles.manyfold;
      key = "";
      mode = "0440";
      owner = username;
    };
    sops.secrets."${stack}/postgres" = {
      sopsFile = cfg.secretsFiles.postgres;
      key = "";
      mode = "0440";
      owner = username;
    };
    home-manager.users."${cfg.username}".home.file = {
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            manyfold:
              image: ghcr.io/manyfold3d/manyfold:latest
              container_name: manyfold_manyfold
              environment:
                PUID: "1001"
                PGID: "1001"
                REDIS_URL: "redis://redis:6379/1"
                DATABASE_ADAPTER: "postgresql"
                DATABASE_HOST: "postgres"
                DATABASE_USER: "manyfold"
                DATABASE_NAME: "manyfold"
              env_file:
                - path: /run/secrets/manyfold/manyfold
                  required: true
              volumes:
                - ${cfg.paths.models}:/libraries
              networks:
                - web
                - manyfold
              labels:
                - traefik.http.routers.manyfold.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.manyfold.tls.certresolver=lets-encrypt
                - traefik.http.routers.manyfold.middlewares=traefik-forward-auth@file
              depends_on:
                - postgres
                - redis

            postgres:
              image: postgres:15
              container_name: manyfold_postgres
              networks:
                - manyfold
              environment:
                POSTGRES_USER: manyfold
              env_file:
                - path: /run/secrets/manyfold/postgres
                  required: true
              volumes:
                - ${cfg.paths.appdata}:/var/lib/postgresql/data

            redis:
              image: redis:7
              networks:
                - manyfold
              container_name: manyfold_redis

          networks:
            web:
              external: true
            manyfold:
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
