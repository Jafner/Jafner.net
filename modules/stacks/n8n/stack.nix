{ lib, config, username, ... }: with lib; let stack = "n8n"; in let cfg = config.stacks.${stack}; in {
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
            n8n:
              image: docker.n8n.io/n8nio/n8n:latest
              container_name: n8n_n8n
              restart: "unless-stopped"
              networks:
                web:
              volumes:
                - ${cfg.paths.appdata}:/home/node/.n8n
              labels:
                - traefik.http.routers.n8n.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.n8n.tls.certresolver=lets-encrypt
              environment:
                - N8N_EDITOR_BASE_URL=https://${cfg.domains.${stack}}/
                - WEBHOOK_URL=https://${cfg.domains.${stack}}/

          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
