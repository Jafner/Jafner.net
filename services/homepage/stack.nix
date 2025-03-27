{ pkgs, config, ... }: let stack = "homepage"; in let cfg = config.modules.stacks.${stack}; in {
  options = with pkgs.lib; {
    modules.stacks.${stack} = {
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
  config =  pkgs.lib.mkIf cfg.enable  {
    sops.secrets."${stack}" = {
      sopsFile = cfg.secretsFile;
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


{ sys, stacks, ... }: let stack = "homepage"; in {
  home-manager.users."${sys.username}".home.file = {
    "${stack}" = {
      enable = true;
      recursive = true;
      source = ./.;
      target = "stacks/${stack}/";
    };
    "${stack}/.env" = {
      enable = true;
      text = ''APPDATA=${stacks.appdata}/${stack}'';
      target = "stacks/${stack}/.env";
    };
  };
}
