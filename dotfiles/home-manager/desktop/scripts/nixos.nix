{ pkgs, ... }: {
  home.packages = with pkgs; [
    ( writeShellApplication {  
      name = "nixos"; 
      runtimeInputs = [
        libnotify
        jq
        git
      ];
      text = ''
        #!/bin/bash

        FLAKE_DIR="$HOME/Git/Jafner.net/dotfiles/"
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
          notify-send "Beginning rebuild"
          sudo nixos-rebuild switch \
            --flake ".#$CURRENT_CONFIGURATION" \
            --impure \
            --show-trace &&\
          notify-send "Rebuilt successfully" 
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
          rebuild) handleUntracked && rebuild && finish;;
          *) error "Unrecognized subcommand $1";;
        esac
      '';
    } )
  ];
}