{ pkgs, config, ... }: let stack = "unifi"; in let cfg = config.modules.stacks.${stack}; in {
  options = with pkgs.lib; {
    modules.stacks.${stack} = {
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
            unifi-controller:
              image: lscr.io/linuxserver/unifi-controller:latest
              container_name: unifi_controller
              restart: "no"
              networks:
                - web
              environment:
                PUID: "1000"
                PGID: "1000"
                MEM_LIMIT: "1024" # in MB
                MEM_STARTUP: "1024" # in MB
              volumes:
                - ${cfg.paths.appdata}/config:/config
              ports:
                - 3478:3478/udp # unifi STUN port
                - 10001:10001/udp # AP discovery port
                - 8080:8080 # communicate with devices
                - 8843:8843 # guest portal http
                - 8880:8880 # guest portal https
                - 6789:6789 # mobile throughput test port
                - 5514:5514/udp # remote syslog
              labels:
                - traefik.http.routers.unifi.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.unifi.tls.certresolver=lets-encrypt
                - traefik.http.routers.unifi.tls=true
                - traefik.http.routers.unifi.middlewares=lan-only@file
                - traefik.http.services.unifi.loadbalancer.server.port=8443
                - traefik.http.services.unifi.loadbalancer.server.scheme=https

          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
