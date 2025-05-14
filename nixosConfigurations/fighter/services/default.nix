{ pkgs
, username
, ...
}: {
  imports = [
    ./traefik.nix
    ./ai
    ./autopirate.nix
    ./keycloak.nix
    ./minecraft.nix
    ./immich.nix
    ./homeassistant.nix
    # ./qbittorrent.nix # TODO
    # ./plex.nix # TODO
    # ./send.nix # TODO
    # ./stash.nix # TODO
    # ./unifi.nix # TODO
    # ./zipline.nix # TODO
  ];
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/docker";
    logDriver = "local";
    rootless.enable = false;
    rootless.setSocketVariable = true;
  };
  users.users.${username}.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.docker-compose ];
  home-manager.users.${username} = {
    programs.lazydocker.enable = true;
    home.file."stacks-dev" = {
      enable = true;
      text = ''
        The stacks-dev directory is used for imperatively managed stacks.
        This is useful for development and testing purposes.
        Stacks whose configuration is not yet stable are stored here.

        Pro tips:

        To import a NixOS-managed stack into the stacks-dev directory, use the following command:
        ```sh
        stack=mystack
        rsync -av /home/admin/stacks/$stack /home/admin/stacks-dev/
        find . -type l -exec sh -c 'cp --remove-destination "$(readlink -f "$0")" "$0"' {} \;
        chmod +w /home/admin/stacks-dev/$stack/* /home/admin/stacks-dev/$stack/.*
        ```
        *Note: This chmod will not work recursively.*
      '';
      target = "stacks-dev/README.md";
    };
  };
}
