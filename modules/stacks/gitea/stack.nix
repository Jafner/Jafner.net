{ lib, config, username, ... }: with lib; let stack = "gitea"; in let cfg = config.stacks.${stack}; in {
  options = {
    stacks.${stack} = {
      enable = mkEnableOption "${stack}";
      secretsFiles = mkOption {
        type = types.submodule {
          options = {
            gitea = mkOption {
              type = types.pathInStore;
              description = "Path to a sops-nix-encrypted secrets file for gitea.";
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
  config = mkIf cfg.enable  {
    sops.secrets."${stack}/gitea" = {
      sopsFile = cfg.secretsFiles.gitea;
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
    home-manager.users."${username}".home.file = {
      "${stack}" = {
        enable = true;
        recursive = true;
        source = ./.;
        target = "stacks/${stack}/";
      };
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            gitea:
              image: gitea/gitea:1.23
              container_name: ${stack}_gitea
              restart: always
              env_file:
                - path: /run/secrets/${stack}/gitea
                  required: true
              networks:
                - web
                - gitea
              volumes:
                - ${cfg.paths.appdata}/gitea:/data
                - /etc/timezone:/etc/timezone:ro
                - /etc/localtime:/etc/localtime:ro
              ports:
                - "2225:22"
              labels:
                - traefik.http.routers.gitea.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.gitea.tls.certresolver=lets-encrypt
                - traefik.http.routers.gitea.tls.options=tls12@file
                - traefik.http.routers.gitea.middlewares=securityheaders@file
                - traefik.http.routers.gitea.service=gitea
                - traefik.http.services.gitea.loadbalancer.server.port=3000

            postgres:
              image: postgres:14
              container_name: ${stack}_postgres
              networks:
                - gitea
              env_file:
                - path: /run/secrets/${stack}/postgres
                  required: true
              volumes:
                - ${cfg.paths.appdata}/postgres:/var/lib/postgresql/data

          networks:
            web:
              external: true
            gitea:
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
