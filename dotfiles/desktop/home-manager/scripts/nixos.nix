{ pkgs, vars, ... }: {
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
        # shellcheck disable=SC2088
        FLAKE_DIR=${vars.flakeDir}
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
          zeditor "${vars.flakeRepo}"
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
          update) handleUntracked && update && finish;;
          clean) garbageCollect && finish;;
          ls) listGenerations;;
          edit) edit;;
          *) error "Unrecognized subcommand $1";;
        esac
      '';
    } )
  ];
}
