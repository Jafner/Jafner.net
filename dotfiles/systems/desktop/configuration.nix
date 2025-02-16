{ sys, pkgs, inputs, ... }: {

  environment.sessionVariables = {
    "FLAKE_DIR" = "/home/${sys.username}/Git/Jafner.net/dotfiles";
  };

  home-manager.backupFileExtension = "bk";
  home-manager.users."${sys.username}" = {
    nixGL = {
      vulkan.enable = true;
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
    };
    home = {
      enableNixpkgsReleaseCheck = false;
      preferXdgDirectories = true;
      username = "${sys.username}";
      homeDirectory = "/home/${sys.username}";
    };
    xdg.systemDirs.data = [
      "/usr/share"
    ];
    programs.home-manager.enable = true;
    home.stateVersion = "24.11";
  };

  users.users."${sys.username}" = {
    extraGroups = [ "input" ];
  };

  programs.ydotool = {
    enable = true;
    group = "wheel";
  };

  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    powerline-symbols
    (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];
}
