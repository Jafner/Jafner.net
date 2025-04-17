{ lib, config, username, ... }: with lib; let stack = "homepage"; in let cfg = config.stacks.${stack}; in {
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
            homepage:
              image: ghcr.io/gethomepage/homepage:latest
              container_name: homepage_homepage
              networks:
                - web
              volumes:
                - ${cfg.paths.appdata}/logs:/app/config/logs
                - ./icons/:/app/public/icons
                - ./config:/app/config/
                - /var/run/docker.sock:/var/run/docker.sock
              labels:
                - traefik.http.routers.homepage.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.homepage.tls.certresolver=lets-encrypt
                - homepage.group=Public
                - homepage.name=Homepage
                - homepage.icon=Homepage.png
                - homepage.href=https://${cfg.domains.${stack}}
                - homepage.description=This page!

          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
