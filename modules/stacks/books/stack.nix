{
  lib,
  config,
  username,
  ...
}:
with lib;
let
  stack = "books";
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
            books = mkOption {
              type = types.str;
              description = "Path to the books library.";
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
              description = "Subdomain for ${stack}.";
              example = "someservice";
            };
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
    home-manager.users."${username}".home.file = {
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            calibre-web:
              container_name: ${stack}
              image: linuxserver/calibre-web:latest
              environment:
                PUID: "1000"
                PGID: "1000"
                TZ: America/Los_Angeles
              volumes:
                - ${cfg.paths.appdata}:/config
                - ${cfg.paths.books}:/books
              labels:
                - traefik.http.routers.calibre-rpg.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.calibre-rpg.tls.certresolver=lets-encrypt
              networks:
                - web
          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
