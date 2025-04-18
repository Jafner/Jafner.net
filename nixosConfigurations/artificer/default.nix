{
  username,
  hostname,
  system,
  ...
}:
{
  imports = [
    ./git.nix
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f222513b-ded1-49fa-b591-20ce86a2fe7f";
    fsType = "ext4";
  };

  virtualisation.docker.enable = true;
  users.users.${username}.extraGroups = [ "docker" ];
  stacks.traefik = {
    enable = true;
    secretsFile = ../../hosts/fighter/secrets/traefik.secrets;
    domainOwnerEmail = "jafner425@gmail.com";
    paths.appdata = "/appdata/traefik";
    domains.base = "jafner.net";
    domains.traefik = "traefik.jafner.net";
  };
  stacks.vaultwarden = {
    enable = true;
    secretsFile = ../../hosts/artificer/admin.token;
    paths.appdata = "/appdata/vaultwarden";
    domains.base = "jafner.net";
    domains.vaultwarden = "bitwarden.jafner.net";
  };

  roles.system = {
    enable = true;
    systemKey = ".ssh/${username}@${hostname}";
  };

  # User Programs
  programs.nh.enable = true;
  home-manager.users."${username}" = {
    programs.home-manager.enable = true;
    programs.nnn.enable = true;
    home = {
      enableNixpkgsReleaseCheck = false;
      preferXdgDirectories = true;
      username = "${username}";
      homeDirectory = "/home/${username}";
    };
    xdg.systemDirs.data = [ "/usr/share" ];
    home.stateVersion = "24.11";
  };

  nix.settings.download-buffer-size = 1073741824;
  nixpkgs = {
    hostPlatform = system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
}
