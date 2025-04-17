{ ... }:
{
  stacks.ai = {
    enable = true;
    paths.appdata = "/appdata/ai";
    domains.base = "jafner.net";
  };
  stacks.autopirate = {
    enable = true;
    paths = {
      appdata = "/appdata/autopirate";
      movies = "/mnt/movies";
      shows = "/mnt/shows";
      music = "/mnt/music";
    };
    domains = {
      base = "jafner.net";
    };
  };
  stacks.books = {
    enable = true;
    paths.appdata = "/appdata/books";
    paths.books = "/mnt/books";
    domains.base = "jafner.net";
  };
  stacks.coder = {
    enable = true;
    secretsFiles.coder = ./hosts/fighter/secrets/coder.secrets;
    paths.appdata = "/appdata/coder";
    domains.base = "jafner.net";
  };
  stacks.gitea = {
    enable = true;
    secretsFiles.gitea = ./hosts/fighter/secrets/gitea.secrets;
    secretsFiles.postgres = ./hosts/fighter/secrets/gitea_postgres.secrets;
    paths.appdata = "/appdata/gitea";
    domains.base = "jafner.net";
  };
  stacks.gitea-runner = {
    enable = true;
    secretsFile = ./hosts/fighter/secrets/gitea-runner.token;
    domains.gitea-host = "git.jafner.net";
  };
  stacks.keycloak = {
    enable = true;
    keycloakAdminUsername = "jafner425@gmail.com";
    secretsFiles = {
      keycloak = ./hosts/fighter/secrets/keycloak.secrets;
      postgres = ./hosts/fighter/secrets/keycloak_postgres.secrets;
      forwardauth = ./hosts/fighter/secrets/forwardauth.secrets;
      forwardauth-privileged = ./hosts/fighter/secrets/forwardauth-privileged.secrets;
    };
    paths.appdata = "/appdata/keycloak";
    domains.base = "jafner.net";
  };
  stacks.minecraft = {
    enable = true;
    paths.appdata = "/appdata/minecraft";
  };
  stacks.traefik = {
    enable = true;
    secretsFile = ./hosts/fighter/secrets/traefik.secrets;
    extraConf = ./hosts/fighter/traefik_config.yaml;
    domainOwnerEmail = "jafner425@gmail.com";
    paths.appdata = "/appdata/traefik";
    domains.base = "jafner.net";
    domains.traefik = "traefik.jafner.net";
  };
}
