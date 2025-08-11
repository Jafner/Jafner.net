{username, ...}: let
  service = "caddy";
in {
  home-manager.users.${username} = {
    home.file."${service}" = {
      enable = true;
      target = "stacks-nix/${service}/compose.yml";
      text = ''
        name: caddy
        services:
          caddy:
            container_name: caddy
            environment:
              CADDY_INGRESS_NETWORKS: caddy
            image: lucaslorentz/caddy-docker-proxy:ci-alpine
            labels:
              caddy_0.email: joey@jafner.net
            networks:
              caddy: null
            ports:
              - mode: ingress
                target: 80
                published: "80"
                protocol: tcp
              - mode: ingress
                target: 443
                published: "443"
                protocol: tcp
            restart: unless-stopped
            volumes:
              - type: bind
                source: /var/run/docker.sock
                target: /var/run/docker.sock
                bind:
                  create_host_path: true
              - type: bind
                source: /appdata/caddy/data
                target: /data
                bind:
                  create_host_path: true
        networks:
          caddy:
            name: caddy
            external: true
      '';
    };
  };
}
