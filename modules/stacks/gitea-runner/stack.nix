{ pkgs, config, ... }: let stack = "gitea-runner"; in let cfg = config.modules.stacks.${stack}; in {
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
        description = "Path to a sops-nix-encrypted secrets file for gitea-runner.";
      };
      domains = mkOption {
        type = types.submodule {
          options = {
            gitea-host = mkOption {
              type = types.str;
              description = "Domain of the Gitea instance to register with.";
              example = "gitea.mydomain.tld";
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
      "${stack}" = {
        enable = true;
        source = ./config.yaml;
        target = "stacks/${stack}/config.yaml";
      };
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          name: "gitea-runner"
          services:
            runner:
              image: gitea/act_runner:latest
              dns: 1.1.1.1
              volumes:
                - ./config.yaml:/config.yaml
                - /run/secrets/gitea-runner:/run/secrets/gitea-runner
                - /var/run/docker.sock:/var/run/docker.sock
              environment:
                CONFIG_FILE: /config.yaml
                GITEA_INSTANCE_URL: https://${cfg.domains.gitea-host}
                GITEA_RUNNER_REGISTRATION_TOKEN_FILE: /run/secrets/gitea-runner
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
