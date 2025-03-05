{ sys, pkgs, git, ... }: {
  users.users."${sys.username}".shell = pkgs.zsh;
  programs.zsh.enable = true;
  home-manager.users."${sys.username}" = {
    home.packages = [
      pkgs.fd
      pkgs.fastfetch
      pkgs.fzf
      pkgs.jq
      pkgs.tree
      pkgs.nethogs
      pkgs.pinentry-all
    ] ++ [
      ( pkgs.writeShellApplication {
        name = "nixos";
        runtimeInputs = [
            pkgs.libnotify
            pkgs.jq
            pkgs.git
        ];
        text = ''
          #!/bin/bash
          # shellcheck disable=SC2088
          FLAKE_DIR="/home/${sys.username}/Git/Jafner.net/dotfiles"
          CURRENT_CONFIGURATION="desktop"
          cd "$FLAKE_DIR"

          handleUntracked() {
            UNTRACKED=$(git ls-files -o --directory --exclude-standard --no-empty-directory)
            if [[ $(echo "$UNTRACKED" | wc -l) -gt 0 ]]; then
              git add -A
              notify-send "Adding untracked files" "$UNTRACKED"
            fi
          }

          rebuild() {
            notify-send "Nixos: Beginning rebuild"
            sudo nixos-rebuild switch \
              --flake ".#$CURRENT_CONFIGURATION" \
              --impure \
              --show-trace &&\
            notify-send "Nixos: Rebuilt successfully"
          }

          build() {
            notify-send "Nixos: Beginning rebuild"
            sudo nixos-rebuild switch \
              --flake ".#$CURRENT_CONFIGURATION" \
              --impure \
              --show-trace &&\
            notify-send "Nixos: Rebuilt successfully"
          }

          update() {
            notify-send "Nixos: Beginning update" "Updating lockfile $FLAKE_DIR/flake.lock"
            nix flake update --flake "$FLAKE_DIR"
            notify-send "Nixos: Update complete" "Finished updating lockfile $FLAKE_DIR/flake.lock"
          }

          garbageCollect() {
            notify-send "Nixos: Collecting garbage" "Deleting generations older than 7 days."
            nix-env --delete-generations 7d &&\
            nix-store --gc --print-dead
            notify-send "Nixos: Garbage collection complete"
          }

          listGenerations() {
            nixos-rebuild list-generations | less
          }

          edit() {
            zeditor "$FLAKE_DIR"
          }

          where() {
            tree "$(realpath "$(which "$1")" | cut -d'/' -f-4)"
          }

          finish() {
            mkdir -p "$HOME/.nixos"
            nixos-rebuild list-generations --json > "$HOME/.nixos/nixos-generations.json"
          }

          error() {
            notify-send "Nixos Script Error" "$@"
            exit 1
          }

          case "$1" in
            rebuild) handleUntracked && rebuild && finish ;;
            build) handleUntracked && build && finish ;;
            update) handleUntracked && update && finish ;;
            clean) garbageCollect && finish ;;
            ls) listGenerations ;;
            edit) edit ;;
            where) where "$2" ;;
            *) error "Unrecognized subcommand $1" ;;
          esac
        '';
      } )
      ( pkgs.writeShellApplication {
        name = "kitty-popup";
        runtimeInputs = [];
        text = ''
          #!/bin/bash

          kitty \
            --override initial_window_width=1280 \
            --override initial_window_height=720 \
            --override remember_window_size=no \
            --class kitty-popup \
            "$@"
        '';
      } )
      # ( pkgs.writeShellApplication {
      #   name = "keyman";
      #   runtimeInputs = [];
      #   text = ''
      #   #!/bin/bash

      #   # Fuck GPG. Miserable UX.

      #   id="${git.email}"
      #   device="desktop"
      #   homedir="/home/${sys.username}/.gpg"
      #   backupdir="/home/${sys.username}/.keys"
      #   mkdir -p "$homedir" "$backupdir"

      #   getPrimaryKeyFingerprint() {
      #     return "$(gpg --list-keys | grep fingerprint | tr -s ' ' | cut -d'=' -f2 | xargs)"
      #   }

      #   bootstrap() {
      #     gpg --quick-generate-key '${git.realname} < ${git.email} >' ed25519 cert 0
      #     gpg --quick-add-key "$(getPrimaryKeyFingerprint)" ed25519 sign 0
      #     gpg --quick-add-key "$(getPrimaryKeyFingerprint)" cv25519 encrypt 0
      #   }

      #   lockPrimary() {
      #     gpg -a --export-secret-key "$(getPrimaryKeyFingerprint)" > "$backupdir/$id.primary.gpg"
      #     gpg -a --export "$(getPrimaryKeyFingerprint)" > "$backupdir/$id.primary.gpg.pub"
      #     gpg -a --export-secret-subkeys "$(getPrimaryKeyFingerprint)" > "/tmp/subkeys.gpg"
      #     gpg --delete-secret-subkeys "$(getPrimaryKeyFingerprint)"
      #     gpg --import "/tmp/subkeys.gpg" && rm "/tmp/subkeys.gpg"
      #   }

      #   unlockPrimary() {
      #     gpg --import "$backupdir/$id.primary.gpg"
      #     if gpg --list-secret-keys | grep -q sec#; then
      #       echo "Unlocked primary key $backupdir/$id.primary.gpg"
      #     else
      #       echo "Failed to unlock primary key $backupdir/$id.primary.gpg"
      #     fi
      #   }

      #   initNewDevice() {
      #     stty icrnl
      #     unlockPrimary
      #     gpg --quick-add-key "$(getPrimaryKeyFingerprint)" ed25519 sign 0
      #     if [[ $(gpg --list-keys | grep "$(date +%Y-%m-%d)" | grep "[S]") -gt 1 ]]; then
      #       echo "More than one loaded signing key is listed for today's date. Please select one:"
      #       while read -r key; do
      #         key_list+=( "$key" )
      #       done< <(gpg --list-keys | grep "$(date +%Y-%m-%d)" | grep "[S]")
      #       select key in "''$''\{key_list[@]}"; do
      #         SUBKEY_FINGERPRINT=$(echo "$key" | cut -d'/' -f2 | cut -d' ' -f1)
      #         export SUBKEY_FINGERPRINT
      #         echo "Subkey fingerprint: $SUBKEY_FINGERPRINT"
      #         break
      #       done
      #     else
      #       SUBKEY_FINGERPRINT=$(gpg --list-keys | grep "$(date +%Y-%m-%d)" | grep "[S]" | cut -d'/' -f2 | cut -d' ' -f1 | head -1)
      #       export SUBKEY_FINGERPRINT
      #     fi
      #     gpg --list-keys | grep "$(date +%Y-%m-%d)" | grep "[S]"
      #     gpg -a --export-secret-key "$SUBKEY_FINGERPRINT" > "$backupdir/$id.$device.gpg"
      #     gpg -a --export "$SUBKEY_FINGERPRINT" > "$backupdir/$id.$device.gpg.pub"

      #     lockPrimary
      #   }

      #   "$@" || declare -F

      #   '';
      # } )
    ];

    programs.kitty = {
      enable = true;
      package = pkgs.kitty;
    };

    programs.btop = {
      enable = true;
      package = pkgs.btop-rocm;
      settings = {
        color_theme = "stylix";
        theme_background = true;
        update_ms = 500;
      };
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
      # TODO: Declare tmux session presets
      # - 'sysmon' session
      #   - 'sysmon' window
      #     - '1' pane: btop
      #     - '2' pane: ssh -o RequestTTY=true admin@192.168.1.23 btop
      #     - '3' pane: ssh -o RequestTTY=true admin@143.110.151.123 btop --utf-force
      #   - 'disks' window
      #     - '1' pane: watch 'df -h -xcifs'
      #     - '2' pane: ssh -o RequestTTY=true admin@192.168.1.23 watch 'df -h -xcifs -xiscsi'
      #     - '3' pane: ssh -o RequestTTY=true admin@143.110.151.123 watch 'df -h'
      #     - '4' pane: ssh -o RequestTTY=true admin@192.168.1.10 watch 'df -h'
      #     - '5' pane: ssh -o RequestTTY=true admin@192.168.1.12 watch 'df -h'
      #   - 'gpus' window
      #     - '1' pane: amdgpu_top
      #     - '2' pane: ssh -o RequestTTY=true admin@192.168.1.23 nvtop
      # - 'ssh' session
      #   - 'fighter' window: ssh admin@192.168.1.23
      #   - 'wizard' window: ssh vyos@192.168.1.1
      #   - 'druid' window: ssh admin@143.110.151.123
      #   - 'paladin' window: ssh admin@192.168.1.12
      #   - 'barbarian' window: ssh admin@192.168.1.10
      # - 'local' session
      #   - 'jafner.net' window
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

    programs.gpg = {
      enable = true;
      homedir = "/home/${sys.username}/.gpg";
      mutableKeys = true;
      mutableTrust = true;
      publicKeys = [  ];
    };
    services.gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      enableScDaemon = false;
      pinentryPackage = pkgs.pinentry-qt;
    };

    xdg.desktopEntries = {
      nixos = {
        icon = "nix-snowflake";
        name = "NixOS";
        categories = [ "System" ];
        type = "Application";
        exec = ''xdg-open "https://mynixos.com"'';
        actions = {
          "Rebuild" = { exec = ''kitty-popup nixos rebuild''; };
          "Update" = { exec = ''kitty-popup nixos update''; };
          "Cleanup" = { exec = ''kitty-popup nixos clean''; };
          "Edit" = { exec = ''nixos edit''; };
        };
      };
    };

    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
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
        bindkey -s '^E' 'ssh $(cat ~/.ssh/profiles | fzf --multi)\n'
        _fzf_compgen_path() {
            fd --hidden --exclude .git . "$1"
        }
        _fzf_compgen_dir() {
            fd --hidden --exclude .git . "$1"
        }
        eval "$(~/.nix-profile/bin/fzf --zsh)"
        fastfetch
      '';
    };
  };
}
