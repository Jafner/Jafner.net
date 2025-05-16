{ username, ... }:
let
  stack = "traefik";
in
{
  sops.secrets."${stack}" = {
    sopsFile = ../cloudflare_dns.secrets;
    key = "";
    mode = "0440";
    format = "dotenv";
    owner = username;
  };
  home-manager.users."${username}".home.file = {
    "${stack}/docker-compose.yml" = {
      enable = true;
      source = ./docker-compose.yml;
      target = "stacks/${stack}/docker-compose.yml";
    };
    "${stack}/traefik.yaml" = {
      enable = true;
      source = ./traefik.yml;
      target = "stacks/${stack}/traefik.yaml";
    };
    "${stack}/config/webfinger.yml" = {
      enable = false;
      text = ''
        http:
          middlewares:
            webfinger:
              plugin:
                webfinger:
                  domain: "jafner.net"
                  resources:
                    "acct:user@jafner.net":
                      subject: "acct:user@jafner.net"
                      aliases:
                        - "https://jafner.net/user"
                      links:
                        - rel: "http://webfinger.net/rel/profile-page"
                          type: "text/html"
                          href: "https://jafner.net/user"
                        - rel: "self"
                          type: "application/activity+json"
                          href: "https://jafner.net/users/user"
                      passthrough: false

      '';
      target = "stacks/${stack}/config/webfinger.yml";
    };
  };
}
