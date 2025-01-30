{ sys, inputs, ... }: let stack = "traefik"; in {
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

  imports = [ inputs.sops-nix.nixosModules.sops ]; 
  sops.secrets."${stack}" = { 
    sopsFile = ./secrets.env;
    key = "";
    mode = "0440";
    owner = sys.username;
    # Access this secrets file in Nix expressions via: 
    #   config.sops.secrets.traefik.path
    # Or in sops-nix templates via:
    #   config.sops.placeholder.traefik.path
    # Or in the shell via:
    #   cat /run/secrets/traefik
  };
  #home-manager.users."${sys.username}".systemd.user.services."${stack}" = {};
}