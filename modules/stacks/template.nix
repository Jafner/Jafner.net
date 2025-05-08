{ pkgs
, config
, ...
}:
let
  stack = "";
in
let
  cfg = config.modules.stacks.${stack};
in
{
  options = with pkgs.lib; {
    modules.stacks.${stack} = {
      enable = mkEnableOption "${stack}";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
      secretsFiles = mkOption {
        type = types.submodule {
          options = {
            ${stack} = mkOption {
              type = types.pathInStore;
              description = "Path to a sops-nix-encrypted secrets file for keycloak.";
            };
            db = mkOption {
              type = types.pathInStore;
              description = "Path to a sops-nix-encrypted secrets file for postgres.";
            };
          };
        };
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
    sops.secrets."${stack}/coder" = {
      sopsFile = cfg.secretsFiles.${stack};
      key = "";
      mode = "0440";
      owner = cfg.username;
    };
    sops.secrets."${stack}/db" = {
      sopsFile = cfg.secretsFiles.db;
      key = "";
      mode = "0440";
      owner = cfg.username;
    };
    home-manager.users."${cfg.username}".home.file = {
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            ${stack}:
              image: image:tag
              container_name: ${stack}_service
              restart: "no"
              networks:
                web:
              volumes:
                - ${cfg.paths.appdata}:/data
              env_file:
                - path: /run/secrets/${stack}
                  required: true
          networks:
            web:
              external: true
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
