{ lib
, config
, username
, ...
}:
with lib; let
  stack = "stash";
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
            videos = mkOption {
              type = types.str;
              description = "Path to video library.";
            };
            galleries = mkOption {
              type = types.str;
              description = "Path to galleries.";
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
            stash:
              container_name: stash
              image: stashapp/stash:latest
              restart: "no"
              mem_limit: 8G
              devices:
                - /dev/dri
              group_add:
                - video
              shm_size: 8G
              volumes:
                - ${cfg.paths.appdata}/.stash:/root/.stash
                - ${cfg.paths.appdata}/generated:/generated
                - ${cfg.paths.appdata}/metadata:/metadata
                - ${cfg.paths.appdata}/cache:/cache
                - ${cfg.paths.videos}/Videos:/media/Videos
                - ${cfg.paths.galleries}/Galleries:/media/Galleries
                - /etc/localtime:/etc/localtime:ro
              environment:
                STASH_STASH: "/media/"
                STASH_GENERATED: "/generated/"
                STASH_METADATA: "/metadata/"
                STASH_CACHE: "/cache/"
              networks:
                - web
              labels:
                - traefik.http.routers.stash.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.stash.tls.certresolver=lets-encrypt
                - traefik.http.routers.stash.middlewares=traefik-forward-auth-privileged@file

          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
