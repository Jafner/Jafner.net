{
  lib,
  config,
  username,
  ...
}:
with lib;
let
  stack = "vaultwarden";
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
      secretsFile = mkOption {
        type = types.pathInStore;
        default = null;
        description = "Path to the stack's sops-nix-encrypted secrets file.";
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
    sops.secrets."${stack}" = {
      sopsFile = cfg.secretsFile;
      key = "";
      mode = "0440";
      owner = username;
    };
    home-manager.users."${username}".home.file = {
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            ${stack}:
              image: vaultwarden/server:1.33.2
              container_name: ${stack}_vaultwarden
              restart: "no"
              env_file:
                - path: /run/secrets/vaultwarden
                  required: true
              environment:
                DOMAIN: "${cfg.domains.${stack}}"
                SIGNUPS_ALLOWED: "true"
              volumes:
                - ${cfg.paths.appdata}/data:/data
              networks:
                - web
              labels:
                - traefik.http.routers.${stack}.middlewares=securityheaders@file
                - traefik.http.routers.${stack}.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.${stack}.tls.certresolver=lets-encrypt
                - traefik.http.routers.${stack}.tls.options=tls12@file
          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
