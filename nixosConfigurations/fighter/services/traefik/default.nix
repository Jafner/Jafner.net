{ username, ... }:
let
  stack = "traefik";
in
{
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
  };
}
