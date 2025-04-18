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
