{ pkgs, ... }:
{
  imports = [
  ];
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };
    printing.enable = true;
    libinput = {
      enable = true;
      mouse.naturalScrolling = true;
      touchpad.naturalScrolling = true;
    };
    flatpak = {
      enable = true;
      update.onActivation = true;
    };
    displayManager = {
      autoLogin = {
        enable = true;
        user = "admin";
      };
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };
  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts noto-fonts-cjk noto-fonts-emoji
    powerline-symbols
    (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; } )
  ];
  home-manager.users.admin = { pkgs, ... }: {
    home.packages = with pkgs; [
      vim 
      fastfetch 
      tree
      btop
      bat
      fd
      eza
      fzf
      cifs-utils
      git
      dig
    ];
    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
  };
  home-manager.users.joey = { pkgs, ... }: {
    home.username = "joey";
    home.homeDirectory = "/home/joey";
    home.file = {
      rbw-config = {
        target = ".config/rbw/config.json";
        text = ''
        {
          "email": "jafner425@gmail.com",
          "sso_id": null,
          "base_url": "https://bitwarden.jafner.tools",
          "identity_url": null,
          "ui_url": null,
          "notifications_url": null,
          "lock_timeout": 3600,
          "sync_interval": 3600,
          "pinentry": "pinentry-curses",
          "client_cert_path": null
        }
        '';
      };
    };
    home.packages = with pkgs; [
      fastfetch
      tree
      btop
      bat
      fd
      eza
      fzf-git-sh
      wl-clipboard
      killall
      pkgs-unstable.fzf
      git
      kdePackages.kdeconnect-kde
      base16-schemes
      rofi-rbw-wayland
      rbw
      pinentry-rofi
      pinentry-all
      nixd
      vesktop
      vlc
      feh
      flatpak
    ];
    programs = {
      home-manager.enable = true;
      git = {
        enable = true;
        userName = "Joey Hafner";
        userEmail = "joey@jafner.net";
        delta.enable = true;
        delta.options = {
          side-by-side = true;
        };
      };
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-vaapi
          obs-vkcapture
          input-overlay
        ];
      };
      rofi = { enable = true; };
      vscode = {
        enable = true;
        package = pkgs.vscodium;
        mutableExtensionsDir = true;
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          continue.continue
        ];
        userSettings = {
          "nix.serverPath" = "nixd";
          "nix.enableLanguageServer" = true;
          "explorer.confirmDragAndDrop" = false;
          "workbench.colorTheme" = "Stylix";
          "git.autofetch" = true;
          "git.confirmSync" = false;
          "editor.fontFamily" = lib.mkForce "'Symbols Nerd Font Mono', 'PowerlineSymbols', 'DejaVu Sans Mono'";
          "git.enableSmartCommit" = true;
        };
        userTasks = {
          version = "2.0.0";
          tasks = [
            {
              type = "shell";
              label = "NixOS Rebuild Switch";
              command = "sudo nixos-rebuild switch --flake ~/Jafner.net/nix";
              problemMatcher =  [];
            }
            {
              type = "shell";
              label = "Home-Manager Switch";
              command = "home-manager switch -b bak --flake ~/Jafner.net/nix";
              problemMatcher =  [];
            }
            {
              label = "System Rebuild";
              dependsOn =  ["NixOS Rebuild Switch" "Home-Manager Switch" ];
              dependsOrder = "sequence";
              problemMatcher = [];
            }
          ];
        };
      };
      kitty = { enable = true; };
      tmux = {
        enable = true;
        newSession = true;
        shell = "$HOME/.nix-profile/bin/zsh";
      };
      zsh = {
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
          nu = "sudo nixos-rebuild switch --flake ~/Jafner.net/nix";
          hmu = "home-manager switch -b bak --flake ~/Jafner.net/nix";
          ngls = "nix-env --profile /nix/var/nix/profiles/system --list-generations";
          ngclean = "nix-collect-garbage --delete-old";
          ngcleanboot = "/run/current-system/bin/switch-to-configuration boot";
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
          source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
        ''; 
      };
      eza = {
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
      vim = {
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
      fzf = {
        enable = true;
        package = pkgs-unstable.fzf;
      };
    };
    services = {
      flatpak = {
        enable = true; 
        uninstallUnmanaged = true;
        packages = [
          { appId = "io.github.zen_browser.zen"; origin = "flathub"; }
        ];
      };
    };
    stylix = {
      enable = true;
      autoEnable = true;
      polarity = "dark";
      targets {
        wofi.enable = true;
        waybar = {
          enableLeftBackColors = true;
          enableCenterBackColors = true;
          enableRightBackColors = true;
        };
      };
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
        sizes = {
          terminal = 14;
          applications = 12;
          popups = 12;
          desktop = 12;
        };
      };
    };
    
    home.stateVersion = "24.05";
  };
  users.users = {
    admin = {
      isNormalUser = true;
      shell = pkgs.zsh;
      description = "${userSettings.user}";
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = let
        authorizedKeys = pkgs.fetchurl {
          url = "https://github.com/Jafner.keys";
          sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
        };
      in pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
    };
    joey = {
      isNormalUser = true;
      shell = pkgs.zsh;
      description = "${userSettings.user}";
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = let
        authorizedKeys = pkgs.fetchurl {
          url = "https://github.com/Jafner.keys";
          sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
        };
      in pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
    };
  };
  environment.systemPackages = with pkgs; [
    git
    mako
    libnotify
    swww
    wofi
    polkit-kde-agent
    xfce.thunar
    ( writeShellScriptBin "nix-installer" '' 
      #!/usr/bin/env bash
      set -euo pipefail
      if [ "$(id -u)" -eq 0 ]; then
        echo "$ERROR! $(basename "$0") should be run as a regular user"
        exit 1
      fi
      if [ ! -d "$HOME/Jafner.net/.git ]; then
        git clone https://gitea.jafner.tools "$HOME/Jafner.net"
      fi

      

      sudo nixos-install --flake "$HOME/Jafner.net/nix"
    '' )
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking = {
    hostName = "${systemSettings.hostname}";
    networkmanager.enable = true;
  };
  security = {
    sudo = {
      enable = true;
      extraRules = [{
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }];
    };
    rtkit.enable = true;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
  time.timeZone = "America/Los_Angeles";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  }; 
  boot.loader = { 
    systemd-boot.enable = true; 
    efi.canTouchEfiVariables = true;
  };
  hardware.pulseaudio.enable = false;
  # DO NOT CHANGE
  system.stateVersion = "24.05"; 
}

