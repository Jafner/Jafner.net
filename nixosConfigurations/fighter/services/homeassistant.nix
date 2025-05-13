{ username, ... }:
let
  stack = "homeassistant";
in
{
  sops.secrets."${stack}/mosquitto.passwd" = {
    sopsFile = ./homeassistant_mosquitto.secrets;
    key = "";
    mode = "0440";
    owner = username;
    format = "binary";
  };
  home-manager.users."${username}".home.file = {
    "${stack}/.env" = {
      enable = true;
      target = "stacks/${stack}/.env";
      text = ''APPDATA=/appdata/${stack}'';
    };
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
              - $APPDATA/homeassistant:/config
              - /run/dbus:/run/dbus:ro
            labels:
              - traefik.http.routers.homeassistant.rule=Host(`homeassistant.jafner.net`)
              - traefik.http.routers.homeassistant.tls.certresolver=lets-encrypt

          mosquitto:
            image: eclipse-mosquitto:latest
            container_name: homeassistant_mosquitto
            networks:
              - homeassistant
            volumes:
              - ./mosquitto.conf:/mosquitto/config/mosquitto.conf
              - /run/secrets/homeassistant/mosquitto.passwd:/mosquitto/config/mosquitto.passwd
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
    "${stack}/mosquitto.conf" = {
      enable = true;
      text = ''
        persistence true
        persistence_location /mosquitto/data/
        user mosquitto
        listener 1883 0.0.0.0
        allow_anonymous false
        log_dest file /mosquitto/log/mosquitto.log
        log_dest stdout
        password_file /mosquitto/config/mosquitto.passwd
      '';
      target = "stacks/${stack}/mosquitto.conf";
    };

  };
}
