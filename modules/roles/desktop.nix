{ pkgs, lib, config, username, ... }: with lib; let cfg = config.roles.desktop; in {
  options = {
    roles.desktop = {
      enable = mkEnableOption "desktop";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    services.pulseaudio.enable = false;
    services.printing.enable = true;
    hardware.wooting.enable = true;
    hardware.xpadneo.enable = true;
    users.users."${cfg.username}".extraGroups = [ "input" ];
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
      nerd-fonts.symbols-only
      #(pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
    programs.nh = { enable = true; flake = "/home/joey/Git/Jafner.net";};
    home-manager.users."${cfg.username}" = {
      home.packages = with pkgs; [
        vesktop
        kdePackages.konsole
        libreoffice-qt6
        obsidian
        protonmail-desktop
        protonmail-bridge-gui
        vlc
        losslesscut-bin
      ];
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
      home = {
        enableNixpkgsReleaseCheck = false;
        preferXdgDirectories = true;
        username = "${cfg.username}";
        homeDirectory = "/home/${cfg.username}";
      };
      xdg.systemDirs.data = [ "/usr/share" ];
      programs.home-manager.enable = true;
      home.stateVersion = "24.11";
      programs.chromium = {
        enable = true;
        package = pkgs.chromium;
      };
      programs.tmux = {
        enable = true;
        newSession = true;
        baseIndex = 1;
        disableConfirmationPrompt = true;
        mouse = true;
        prefix = "C-b";
        resizeAmount = 2;
        plugins = with pkgs; [
          { plugin = tmuxPlugins.resurrect; }
          { plugin = tmuxPlugins.tmux-fzf; }
        ];
        shell = "${pkgs.zsh.shellPath}";
      };
      programs.vim = {
        enable = true;
        defaultEditor = false;
        settings = {
          copyindent = true;
          relativenumber = true;
          expandtab = true;
          tabstop = 2;
        };
        extraConfig = ''
          set nocompatible
          filetype on
          filetype plugin on
          filetype indent on
          syntax on
          set cursorline
          set wildmenu
          set wildmode=list:longest
        '';
      };
      nixGL = {
        vulkan.enable = true;
        defaultWrapper = "mesa";
        installScripts = [ "mesa" ];
      };
    };
  };
}
