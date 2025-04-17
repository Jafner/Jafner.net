{
  lib,
  config,
  username,
  ...
}:
with lib;
let
  stack = "keycloak";
in
let
  cfg = config.stacks.${stack};
in
{
  options = {
    stacks.${stack} = {
      enable = mkEnableOption "${stack}";
      keycloakAdminUsername = mkOption {
        type = types.str;
        default = "admin";
        description = "Username for the generated default admin user.";
        example = "john";
      };
      secretsFiles = mkOption {
        type = types.submodule {
          options = {
            keycloak = mkOption {
              type = types.pathInStore;
              description = "Path to a sops-nix-encrypted secrets file for keycloak.";
            };
            postgres = mkOption {
              type = types.pathInStore;
              description = "Path to a sops-nix-encrypted secrets file for postgres.";
            };
            forwardauth = mkOption {
              type = types.pathInStore;
              description = "Path to a sops-nix-encrypted secrets file for forwardauth.";
            };
            forwardauth-privileged = mkOption {
              type = types.pathInStore;
              description = "Path to a sops-nix-encrypted secrets file for forwardauth-privileged.";
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
              default = "${stack}.${cfg.domains.base}";
              description = "Domain for ${stack}.";
              example = "service.mydomain.tld";
            };
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
    sops.secrets."${stack}/keycloak" = {
      sopsFile = cfg.secretsFiles.keycloak;
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
    sops.secrets."${stack}/forwardauth" = {
      sopsFile = cfg.secretsFiles.forwardauth;
      key = "";
      mode = "0440";
      owner = username;
    };
    sops.secrets."${stack}/forwardauth-privileged" = {
      sopsFile = cfg.secretsFiles.forwardauth-privileged;
      key = "";
      mode = "0440";
      owner = username;
    };
    home-manager.users."${username}".home.file = {
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            keycloak:
              image: quay.io/keycloak/keycloak:latest
              container_name: ${stack}_keycloak
              networks:
                keycloak:
                  aliases:
                    - keycloak
                web:
                  aliases:
                    - keycloak
              restart: "no"
              depends_on:
                - postgres
              command: start --hostname=${cfg.domains.${stack}}
              environment:
                KC_DB: postgres
                KC_DB_URL: jdbc:postgresql://postgres/keycloak
                KC_DB_USERNAME: keycloak
                KC_PROXY_HEADERS: xforwarded
                KC_HTTP_ENABLED: true
                KC_HEALTH_ENABLED: true
                KC_METRICS_ENABLED: true
                KEYCLOAK_ADMIN: ${cfg.keycloakAdminUsername}
              env_file:
                - path: /run/secrets/${stack}/keycloak
                  required: true
              labels:
                traefik.http.routers.keycloak.rule: Host(`${cfg.domains.${stack}}`)
                traefik.http.routers.keycloak.tls.certresolver: lets-encrypt
                traefik.http.routers.keycloak.middlewares: keycloak-redirect
                traefik.http.services.keycloak.loadbalancer.server.port: 8080
                traefik.http.middlewares.keycloak-redirect.redirectregex.regex: ^https:\\/\\/([^\\//]+)\\/?$$"
                traefik.http.middlewares.keycloak-redirect.redirectregex.replacement: https://$$1/admin"

            forwardauth:
              image: mesosphere/traefik-forward-auth:latest
              container_name: ${stack}_forwardauth
              networks:
                web:
                  aliases:
                    - forwardauth
              restart: "always"
              command: "./traefik-forward-auth"
              depends_on:
                - keycloak
              environment:
                PROVIDER_URI: "https://${cfg.domains.${stack}}/realms/${cfg.domains.base}"
                CLIENT_ID: "traefik-forward-auth"
                LOG_LEVEL: "debug"
              env_file:
                - path: /run/secrets/${stack}/forwardauth
                  required: true
              labels:
                - "traefik.enable=false"
                - "traefik.http.routers.forwardauth.rule=Path(`/_oauth`)"
                - "traefik.http.routers.forwardauth.tls.certresolver=lets-encrypt"

            forwardauth-privileged:
              image: mesosphere/traefik-forward-auth:latest
              container_name: ${stack}_forwardauth-privileged
              networks:
                web:
                  aliases:
                    - forwardauth-privileged
              restart: "always"
              command: "./traefik-forward-auth"
              depends_on:
                - keycloak
              environment:
                PROVIDER_URI: "https://${cfg.domains.${stack}}/realms/${cfg.domains.base}"
                CLIENT_ID: "traefik-forward-auth-privileged"
                LOG_LEVEL: "debug"
              env_file:
                - path: /run/secrets/${stack}/forwardauth-privileged
                  required: true
              labels:
                - "traefik.enable=false"
                - "traefik.http.routers.forwardauth-privileged.rule=Path(`/_oauth`)"
                - "traefik.http.routers.forwardauth-privileged.tls.certresolver=lets-encrypt"

            postgres:
              image: postgres:latest
              container_name: ${stack}_postgres
              networks:
                - keycloak
              environment:
                POSTGRES_DB: keycloak
                POSTGRES_USER: keycloak
              env_file:
               - path: /run/secrets/${stack}/postgres
                 required: true
              volumes:
                - ${cfg.paths.appdata}:/var/lib/postgresql/data

          networks:
            web:
              external: true
            keycloak:

        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
