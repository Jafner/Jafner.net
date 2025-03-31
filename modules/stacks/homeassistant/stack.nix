{ pkgs, lib, config, username, ... }: with lib; let stack = "homeassistant"; in let cfg = config.stacks.${stack}; in {
  options = with pkgs.lib; {
    stacks.${stack} = {
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
  config = mkIf cfg.enable  {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    services.dbus.implementation = "broker";
    sops.secrets."${stack}/mosquitto" = {
      sopsFile = cfg.secretsFile;
      key = "";
      mode = "0440";
      format = "binary";
      owner = username;
    };
    home-manager.users."${username}".home.file = {
      "${stack}/docker-compose.yml" = {
        enable = true;
        text = ''
          services:
            homeassistant:
              image: lscr.io/linuxserver/homeassistant:latest
              container_name: homeassistant_homeassistant
              environment:
                PUID: "1001"
                PGID: "1001"
                TZ: "America/Los_Angeles"
              networks:
                - web
                - homeassistant
              volumes:
                - ${cfg.paths.appdata}/homeassistant:/config
                - /run/dbus:/run/dbus:ro
              labels:
                - traefik.http.routers.homeassistant.rule=Host(`${cfg.domains.${stack}}`)
                - traefik.http.routers.homeassistant.tls.certresolver=lets-encrypt

            mosquitto:
              image: eclipse-mosquitto:latest
              container_name: homeassistant_mosquitto
              networks:
                - homeassistant
              volumes:
                - ./mosquitto.conf:/mosquitto/config/mosquitto.conf
                - /run/secrets/homeassistant/mosquitto:/mosquitto/config/mosquitto.passwd
                - ${cfg.paths.appdata}/mosquitto:/mosquitto/data
              ports:
                - 12883:1883
                - 19001:9001

          networks:
            web:
              external: true
            homeassistant:
        '';
        target = "stacks/${stack}/docker-compose.yml";
      };
    };
  };
}
