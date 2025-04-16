{ username, ... }: {
  networking.firewall.allowedTCPPorts = [ 7860 ];
  virtualisation.docker.enable = true;
  users.users.${username}.extraGroups = [ "docker" ];
}
