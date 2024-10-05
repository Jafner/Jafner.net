{ config, pkgs, pkgs-unstable, ... }:

{
  sops = {
    age.sshKeyPaths = [ "/home/joey/.ssh/main_id_ed25519" ];
    defaultSopsFile = ./secrets.yaml;
  };
  stylix = {
    enable = true;
    autoEnable = false;
    polarity = "dark";
    image = ./plasma6.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    fonts = {
      monospace = {
        name = "DejaVu Sans Mono";
        package = pkgs.dejavu_fonts;
      };
      serif = {
        name = "DejaVu Serif";
        package = pkgs.dejavu_fonts;
      };
      sansSerif = {
        name = "DejaVu Sans";
        package = pkgs.dejavu_fonts;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
    };
    targets = {
      bat.enable = true;
      btop.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      gtk.enable = true;
      kde.enable = false; # Currently, this breaks most of KDE. 
      kitty.enable = true;
      tmux.enable = true;
      vesktop.enable = true;
      vim.enable = true;
      vscode.enable = true;
    };
  };
  services.flatpak = {
    enable = true;
    packages = [
      "com.discordapp.Discord/x86_64/stable"
      "com.github.IsmaelMartinez.teams_for_linux/x86_64/stable"
      "com.obsproject.Studio/x86_64/stable"
      "com.obsproject.Studio/x86_64/stable"
      "com.obsproject.Studio.Plugin.OBSVkCapture/x86_64/stable"
      "com.obsproject.Studio.Plugin.OBSVkCapture/x86_64/stable"
      "com.spotify.Client/x86_64/stable"
      "com.spotify.Client/x86_64/stable"
      "com.usebottles.bottles/x86_64/stable"
      "com.usebottles.bottles/x86_64/stable"
      "dev.alextren.Spot/x86_64/stable"
      "dev.vencord.Vesktop/x86_64/stable"
      "dev.vencord.Vesktop/x86_64/stable"
      "io.github.f3d_app.f3d/x86_64/stable"
      "io.github.zen_browser.zen/x86_64/stable"
      "io.github.zen_browser.zen/x86_64/stable"
      "io.missioncenter.MissionCenter/x86_64/stable"
      "io.missioncenter.MissionCenter/x86_64/stable"
      "md.obsidian.Obsidian/x86_64/stable"
      "md.obsidian.Obsidian/x86_64/stable"
      "no.mifi.losslesscut/x86_64/stable"
      "no.mifi.losslesscut/x86_64/stable"
      "org.chromium.Chromium/x86_64/stable"
      "org.chromium.Chromium/x86_64/stable"
      "org.chromium.Chromium.Codecs/x86_64/stable"
      "org.chromium.Chromium.Codecs/x86_64/stable"
      "org.fedoraproject.KDE6Platform/x86_64/f40"
      "org.fedoraproject.Platform/x86_64/f40"
      "org.freedesktop.Platform/x86_64/22.08"
      "org.freedesktop.Platform/x86_64/23.08"
      "org.freedesktop.Platform/x86_64/24.08"
      "org.freedesktop.Platform/x86_64/24.08"
      "org.freedesktop.Platform.GL.default/x86_64/23.08"
      "org.freedesktop.Platform.GL.default/x86_64/23.08"
      "org.freedesktop.Platform.GL.default/x86_64/23.08-extra"
      "org.freedesktop.Platform.GL.default/x86_64/23.08-extra"
      "org.freedesktop.Platform.GL.default/x86_64/24.08"
      "org.freedesktop.Platform.GL.default/x86_64/24.08"
      "org.freedesktop.Platform.GL.default/x86_64/24.08extra"
      "org.freedesktop.Platform.GL.default/x86_64/24.08extra"
      "org.freedesktop.Platform.GL32.default/x86_64/23.08"
      "org.freedesktop.Platform.GL32.default/x86_64/23.08"
      "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08"
      "org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/23.08"
      "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/22.08"
      "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08"
      "org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/23.08"
      "org.freedesktop.Platform.ffmpeg-full/x86_64/23.08"
      "org.freedesktop.Platform.ffmpeg-full/x86_64/23.08"
      "org.freedesktop.Platform.ffmpeg-full/x86_64/24.08"
      "org.freedesktop.Platform.ffmpeg_full.i386/x86_64/23.08"
      "org.freedesktop.Platform.ffmpeg_full.i386/x86_64/23.08"
      "org.freedesktop.Platform.openh264/x86_64/2.2.0"
      "org.freedesktop.Platform.openh264/x86_64/2.2.0"
      "org.freedesktop.Platform.openh264/x86_64/2.4.1"
      "org.freedesktop.Platform.openh264/x86_64/2.4.1"
      "org.freedesktop.Sdk/x86_64/23.08"
      "org.gimp.GIMP/x86_64/stable"
      "org.gnome.Boxes/x86_64/stable"
      "org.gnome.Boxes.Extension.OsinfoDb/x86_64/stable"
      "org.gnome.Platform/x86_64/45"
      "org.gnome.Platform/x86_64/46"
      "org.gnome.Platform/x86_64/47"
      "org.gnome.Platform/x86_64/47"
      "org.gnome.Platform.Compat.i386/x86_64/46"
      "org.gnome.Platform.Compat.i386/x86_64/46"
      "org.gtk.Gtk3theme.Breeze/x86_64/3.22"
      "org.gtk.Gtk3theme.adw-gtk3/x86_64/3.22"
      "org.gtk.Gtk3theme.adw-gtk3/x86_64/3.22"
      "org.kde.KStyle.Adwaita/x86_64/5.15-23.08"
      "org.kde.KStyle.Adwaita/x86_64/6.6"
      "org.kde.KStyle.Adwaita/x86_64/6.7"
      "org.kde.Platform/x86_64/5.15-23.08"
      "org.kde.Platform/x86_64/6.6"
      "org.kde.Platform/x86_64/6.7"
      "org.kde.Platform/x86_64/6.7"
      "org.kde.PlatformTheme.QGnomePlatform/x86_64/5.15-23.08"
      "org.kde.PlatformTheme.QGnomePlatform/x86_64/6.6"
      "org.kde.WaylandDecoration.QAdwaitaDecorations/x86_64/5.15-23.08"
      "org.kde.WaylandDecoration.QAdwaitaDecorations/x86_64/6.6"
      "org.kde.WaylandDecoration.QGnomePlatform-decoration/x86_64/5.15-23.08"
      "org.kde.kontact/x86_64/stable"
      "org.kde.neochat/x86_64/stable"
      "org.mozilla.Thunderbird/x86_64/stable"
      "org.prismlauncher.PrismLauncher/x86_64/stable"
      "org.prismlauncher.PrismLauncher/x86_64/stable"
      "org.videolan.VLC/x86_64/stable"
      "org.videolan.VLC/x86_64/stable"
      "org.winehq.Wine.DLLs.dxvk/x86_64/stable-23.08"
      "org.winehq.Wine.DLLs.dxvk/x86_64/stable-23.08"
      "org.winehq.Wine.gecko/x86_64/stable-23.08"
      "org.winehq.Wine.gecko/x86_64/stable-23.08"
      "org.winehq.Wine.mono/x86_64/stable-23.08"
      "org.winehq.Wine.mono/x86_64/stable-23.08"
      "re.sonny.Tangram/x86_64/stable"
      "us.zoom.Zoom/x86_64/stable"
      "xyz.z3ntu.razergenie/x86_64/stable"
    ];
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      continue.continue
    ];
    userSettings = {
      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "security.workspace.trust.untrustedFiles" = "open";
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.profiles.linux.zsh.path" = "/usr/bin/zsh"; 
    };
  };
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
      obs-vkcapture
      input-overlay
    ];
  };
  programs.git = {
    enable = true;
    userName = "Joey Hafner";
    userEmail = "joey@jafner.net";
    extraConfig = {
      core.sshCommand = "ssh -i /home/joey/.ssh/main_id_ed25519";
    };
    delta.enable = true;
    delta.options = {
      side-by-side = true;
    };
  };
  programs.kitty = { 
    enable = true; 
    package = 
    pkgs.writeShellScriptBin "kitty" ''
        #!/bin/sh
        ${pkgs-unstable.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs-unstable.kitty}/bin/kitty "$@"
      '';
  };
  programs.tmux = {
    enable = true;
    newSession = true;
    shell = "$HOME/.nix-profile/bin/zsh";
  };
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      bat = "bat --paging=never --color=always";
      fd = "fd -Lu";
      ls = "eza"; 
      lt = "eza --tree";
      fetch = "fastfetch";
      neofetch = "fetch";
      find = ''fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'';
      hmu = "home-manager switch ~/.config/home-manager";
      kitty = "nixGL kitty";
      fzf-ssh = "ssh $(cat ~/.ssh/profiles | fzf --height 20%)";
      fsh = "fzf-ssh";
    };
    history = {
      share = true;
      save = 10000;
      size = 10000;
      expireDuplicatesFirst = false;
      extended = false;
      ignoreAllDups = false;
      ignoreDups = true;
    };
    initExtra = ''
      bindkey '^[[1;5A' history-search-backward # Ctrl+Up-arrow
      bindkey '^[[1;5B' history-search-forward # Ctrl+Down-arrow
      bindkey '^[[1;5D' backward-word # Ctrl+Left-arrow
      bindkey '^[[1;5C' forward-word # Ctrl+Right-arrow
      bindkey '^[[H' beginning-of-line # Home
      bindkey '^[[F' end-of-line # End
      bindkey '^[w' kill-region # Delete
      bindkey '^I^I' autosuggest-accept # Tab, Tab
      bindkey '^[' autosuggest-clear # Esc
      _fzf_compgen_path() {
          fd --hidden --exclude .git . "$1"
      }
      _fzf_compgen_dir() {
          fd --hidden --exclude .git . "$1"
      }
      eval "$(~/.nix-profile/bin/fzf --zsh)"
    '';
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    extraOptions = [
      "--color=always"
      "--long"
      "--icons=always"
      "--no-time"
      "--no-user"
    ];
  };
  programs.vim = {
    enable = true;
    defaultEditor = true;
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
  programs.fzf = {
    enable = true;
    package = pkgs-unstable.fzf;
  };
  home.enableNixpkgsReleaseCheck = false;
  home.preferXdgDirectories = true;
  home.username = "joey";
  home.homeDirectory = "/home/joey";
  home.stateVersion = "24.05"; 
  home.packages = with pkgs; [
    flatpak
    fastfetch
    nixd
    git kdePackages.kdeconnect-kde
    vesktop
    vlc
    tree btop
    bat fd eza fzf-git-sh
    wl-clipboard
    base16-schemes
    pkgs-unstable.fzf
  ];
  home.file = {
    "continue-config.json" = {
      source = ./continue-config.json;
      target = ".continue/config.json";
    };

  };
  home.sessionVariables = {
  };
  programs.home-manager.enable = true;
  xdg.systemDirs.data = [
    "/usr/share"
  ];
}
