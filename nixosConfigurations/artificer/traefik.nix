{ username, ... }:
let
  stack = "traefik";
  domainOwnerEmail = "jafner425@gmail.com";
in
{
  home-manager.users."${username}".home.file = {
    "${stack}/docker-compose.yml" = {
      enable = true;
      text = ''
        services:
          ${stack}:
            image: traefik:latest
            container_name: ${stack}_traefik
            restart: "no"
            networks:
              web:
                ipv4_address: 172.18.0.100
            ports:
              - 80:80
              - 443:443
            volumes:
              - /var/run/docker.sock:/var/run/docker.sock:ro
              - ./traefik.yaml:/traefik.yaml
              - ./config:/config
              - /appdata/traefik/acme.json:/acme.json
        networks:
          web:
            external: true
      '';
      target = "stacks/${stack}/docker-compose.yml";
    };
    "${stack}/traefik.yaml" = {
      enable = true;
      text = ''
        entryPoints:
          web:
            address: :80
            http:
              redirections:
                entryPoint:
                  to: websecure
                  scheme: https
          websecure:
            address: :443

        certificatesResolvers:
          lets-encrypt:
            acme:
              email: ${domainOwnerEmail}
              storage: acme.json
              tlsChallenge: {}
          lets-encrypt-dns01:
            acme:
              email: ${domainOwnerEmail}
              storage: acme-dns01.json
              dnsChallenge:
                provider: cloudflare
                resolvers:
                  - "1.1.1.1:53"
                  - "8.8.8.8:53"

        api:
          insecure: true
          dashboard: true

        serversTransport:
          insecureSkipVerify: true

        providers:
          docker:
            endpoint: "unix:///var/run/docker.sock"
            watch: true
            network: web
          file:
            directory: /config
            watch: false
      '';
      target = "stacks/${stack}/traefik.yaml";
    };
  };
}
