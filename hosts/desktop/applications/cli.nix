{ sys, pkgs, ... }: {
  home-manager.users."${sys.username}" = {
    home.packages = with pkgs; [ 
      fd
      fastfetch
      jq
      tree
      pinentry-all
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
    ];
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
      maxCacheTtl = 86400;
      defaultCacheTtl = 86400;
    };
  };
}