{ sys, ... }: let stack = "send"; in {
  home-manager.users."${sys.username}".home.file = {
    "${stack}" = {
      enable = true;
      recursive = true;
      source = ./.;
      target = "stacks/${stack}/";
    };
    "${stack}/.env" = {
      enable = true;
      text = ''DOCKER_DATA=${sys.dockerData}'';
      target = "stacks/${stack}/.env";
    };
  };
  #home-manager.users."${sys.username}".systemd.user.services."${stack}" = {};
}