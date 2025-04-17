{ lib, config, username, ... }: with lib; let stack = "uptimekuma"; in let cfg = config.stacks.${stack}; in {
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
            ${stack}:
              image: louislam/uptime-kuma:latest
              container_name: ${stack}
              restart: "no"
              networks:
                web:
              volumes:
                - ${cfg.paths.appdata}/uptime-kuma:/data
                - /var/run/docker.sock:/var/run/docker.sock
              labels:
                - traefik.http.routers.uptime-kuma.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.uptime-kuma.tls.certresolver=lets-encrypt
          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
