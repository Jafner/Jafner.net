{ lib, config, username, ... }: with lib; let stack = "send"; in let cfg = config.stacks.${stack}; in {
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
  config = mkIf cfg.enable  {
    home-manager.users."${username}".home.file = {
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            send:
              image: registry.gitlab.com/timvisee/send:latest
              user: 1000:1000
              container_name: send_send
              restart: "no"
              networks:
                - send
                - web
              environment:
                VIRTUAL_HOST: 0.0.0.0
                VIRTUAL_PORT: 1234
                DHPARAM_GENERATION: false
                NODE_ENV: production
                BASE_URL: https://${cfg.domains.${stack}}
                PORT: 1234
                REDIS_HOST: redis
                FILE_DIR: /uploads
                MAX_FILE_SIZE: 42949672960 # 40 GiB
              volumes:
                - ${cfg.paths.appdata}/uploads:/uploads
              labels:
                - traefik.http.routers.send.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.send.tls.certresolver=lets-encrypt-dns01
                - traefik.http.routers.send.tls.options=tls12@file
                - traefik.http.services.send.loadbalancer.server.port=1234

            redis:
              image: 'redis:alpine'
              container_name: send_redis
              networks:
                - send
              restart: "no"

          networks:
            web:
              external: true
            send:
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
