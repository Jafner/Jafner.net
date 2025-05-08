{ lib
, config
, username
, ...
}:
with lib; let
  stack = "ai";
in
let
  cfg = config.stacks.${stack};
in
{
  options = {
    stacks.${stack} = {
      enable = mkEnableOption "${stack}";
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
              description = "Domain for ${stack}";
              example = "someservice.mydomain.tld";
            };
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
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
          name: "ai"
          services:
            sillytavern:
              container_name: ai_sillytavern
              image: ghcr.io/sillytavern/sillytavern:1.12.2
              networks:
                - web
              privileged: false
              volumes:
                - ${cfg.paths.appdata}/config:/home/node/app/config
                - ${cfg.paths.appdata}/data:/home/node/app/data
                - ${cfg.paths.appdata}/plugins:/home/node/app/plugins
              environment:
                TZ: America/Los_Angeles
              labels:
                - traefik.http.routers.sillytavern.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.sillytavern.tls.certresolver=lets-encrypt
                - traefik.http.routers.sillytavern.middlewares=traefik-forward-auth-privileged@file

          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
