{ lib, config, username, ... }: with lib; let stack = "wireguard"; in let cfg = config.stacks.${stack}; in {
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
            wg-easy:
              image: weejewel/wg-easy:latest
              container_name: wireguard_wg-easy
              restart: "no"
              environment:
                WG_HOST: ${cfg.domains.${stack}}
                WG_PORT: 53820
                WG_DEFAULT_DNS: 10.0.0.1
              ports:
                - 53820:51820/udp
              networks:
                - web
              volumes:
                - ${cfg.paths.appdata}:/etc/wireguard
              cap_add:
                - NET_ADMIN
                - SYS_MODULE
              sysctls:
                - net.ipv4.conf.all.src_valid_mark=1
                - net.ipv4.ip_forward=1
              labels:
                - traefik.http.routers.wg-easy.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.wg-easy.tls.certresolver=lets-encrypt
                - traefik.http.services.wg-easy.loadbalancer.server.port=51821
                - traefik.http.routers.wg-easy.middlewares=traefik-forward-auth@file

          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
