{username, ...}: let
  service = "dockge";
in {
  home-manager.users.${username} = {
    home.file."${service}" = {
      enable = true;
      target = "stacks-nix/${service}/compose.yml";
      text = ''
        name: dockge
        services:
          dockge:
            container_name: dockge
            environment:
              DOCKGE_STACKS_DIR: /appdata/dockge/stacks
            image: louislam/dockge:latest
            labels:
              caddy: dockge.jafner.net
              caddy.reverse_proxy: '{{upstreams 5001}}'
            networks:
              caddy: null
            restart: unless-stopped
            volumes:
              - type: bind
                source: /var/run/docker.sock
                target: /var/run/docker.sock
                bind:
                  create_host_path: true
              - type: bind
                source: /appdata/dockge/data
                target: /app/data
                bind:
                  create_host_path: true
              - type: bind
                source: /appdata/dockge/stacks
                target: /appdata/dockge/stacks
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
