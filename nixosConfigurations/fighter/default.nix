{ pkgs, username, hostname, system, ... }: {
  imports = [
    ./filesystems.nix
    ./git.nix
    ./hardware.nix
    ./home-manager.nix
    ./iscsi-shares.nix
    ./networking.nix
  ];

  roles.system = {
    enable = true;
    systemKey = ".ssh/${username}@${hostname}";
  };

  # User Programs
  programs.nh = { enable = true; flake = "/home/${username}/Jafner.net";};
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

  environment.systemPackages = with pkgs; [ cifs-utils ];

  nix.settings.download-buffer-size = 1073741824;
  nixpkgs = {
    hostPlatform = system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    powerline-symbols
    nerd-fonts.symbols-only
  ];
}
