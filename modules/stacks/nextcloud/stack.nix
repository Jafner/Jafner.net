{ pkgs, lib, config, username, ... }: with lib; let stack = "nextcloud"; in let cfg = config.stacks.${stack}; in {
  options = with pkgs.lib; {
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
  config = mkIf cfg.enable  {
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
            nextcloud:
              image: lscr.io/linuxserver/nextcloud:latest
              container_name: nextcloud_nextcloud
              environment:
                PUID: "1000"
                PGID: "1000"
                TZ: "America/Los_Angeles"
              depends_on:
                - mariadb
              labels:
                - traefik.http.routers.nextcloud.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.nextcloud.tls.certresolver=lets-encrypt
                - traefik.http.routers.nextcloud.middlewares=nextcloud-headers@file,nextcloud-redirect@file
              networks:
                - web
                - nextcloud
              volumes:
                - ${cfg.paths.appdata}/config:/config
                - ${cfg.paths.appdata}/data:/data

            mariadb:
              image: lscr.io/linuxserver/mariadb:latest
              container_name: nextcloud_mariadb
              networks:
                - nextcloud
              environment:
                PUID: "1000"
                PGID: "1000"
                TZ: "America/Los_Angeles"
                MYSQL_DATABASE: "nextcloud"
                MYSQL_USER: "ncuser"
              env_file:
                - path: /run/secrets/nextcloud
                  required: true
              volumes:
                - ${cfg.paths.appdata}/mariadb:/config

            redis:
              image: redis:latest
              container_name: nextcloud_redis
              networks:
                - nextcloud
              volumes:
                - ${cfg.paths.appdata}/redis:/data

          networks:
            web:
              external: true
            nextcloud:
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
