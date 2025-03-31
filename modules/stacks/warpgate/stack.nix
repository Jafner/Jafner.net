{ pkgs, lib, config, username, ... }: with lib; let stack = "warpgate"; in let cfg = config.stacks.${stack}; in {
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
            warpgate:
              image: ghcr.io/warp-tech/warpgate
              container_name: warpgate_warpgate
              ports:
                - 2222:2222
                - 33306:33306
              volumes:
                - ${cfg.paths.appdata}:/data
              labels:
                - traefik.http.routers.warpgate.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.warpgate.tls.certresolver=lets-encrypt
                - traefik.http.services.warpgate.loadbalancer.server.port=8888
                - traefik.http.services.warpgate.loadbalancer.server.scheme=https
              stdin_open: true
              tty: true
              networks:
                web:
          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
