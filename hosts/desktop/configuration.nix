{ sys, pkgs, inputs, ... }: {
  home-manager.sharedModules = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.stylix.homeManagerModules.stylix
  ];
  home-manager.backupFileExtension = "bk";
  home-manager.users."${sys.username}" = {
    home.file.".ssh/config" = {
      enable = true;
      text = ''
        Host *
            ForwardAgent yes
            IdentityFile ~/.ssh/joey.desktop@jafner.net
      '';
      target = ".ssh/config";
    };
    home.file.".ssh/profiles" = {
      enable = true;
      text = ''
        vyos@wizard
        admin@paladin
        admin@fighter
        admin@artificer
        admin@champion
      '';
      target = ".ssh/profiles";
    };
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
    xdg.systemDirs.data = [ "/usr/share" ];
    programs.home-manager.enable = true;
    home.stateVersion = "24.11";
  };
  nix.settings.download-buffer-size = 1073741824;

  users.users."${sys.username}".extraGroups = [ "input" ];

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
