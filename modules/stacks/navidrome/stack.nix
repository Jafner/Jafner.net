{ lib
, config
, username
, ...
}:
with lib; let
  stack = "navidrome";
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
    home-manager.users."${username}".home.file = {
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            navidrome:
              image: deluan/navidrome:latest
              container_name: navidrome_navidrome
              restart: "no"
              user: 1001:1001
              networks:
                - web
              environment:
                ND_SCANSCHEDULE: 1h
                ND_LOGLEVEL: info
                ND_SESSIONTIMEOUT: 24h
                ND_BASEURL: "https://${cfg.domains.${stack}}"
              volumes:
                - "${cfg.paths.music}:/music:ro"
                - "${cfg.paths.appdata}:/data"
              labels:
                - traefik.http.routers.navidrome.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.navidrome.tls.certresolver=lets-encrypt
                - traefik.http.services.navidrome.loadbalancer.server.port=4533

          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
