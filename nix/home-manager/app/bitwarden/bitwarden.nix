{ pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs; [
    bitwarden-cli
    jq
    wl-clipboard
    tmux
    ( writeShellApplication {
      name = "fzf-bw"; # { bwJson }: { itemPreviewJson }
      runtimeInputs = [
        wl-clipboard
        ( writeShellApplication {
          name = "fzf-bw-getUser"; # { itemJson }: { itemUsername }
          runtimeInputs = [ jq ];
          text = ''echo "$1" | jq -r '.user' '';
        } )
        ( writeShellApplication {
          name = "fzf-bw-getPass"; # { itemJson }: { itemPassword }
          runtimeInputs = [ jq ];
          text = ''echo "$1" | jq -r '.password' '';
        } )
        ( writeShellApplication {
          name = "fzf-bw-getItem"; # { itemUuid, bwJson }: { itemJson }
          runtimeInputs = [ jq ];
          text = ''echo "$2" | jq -c --arg id "$1" '.[] | select(.id==$id) | {"user": "\(.login.username)", "password": "\(.login.password)", "name": "\(.name)"}' '';
        } )
        ( writeShellApplication {
          name = "fzf-bw-selector"; # { bwJson }: { itemUuid }
          runtimeInputs = [ jq pkgs-unstable.fzf ];
          text = ''export json="$1"; echo "$json" | jq -r '.[].id' | fzf --preview='fzf-bw-getItem {} "$json" | jq -C' --disabled '';
          excludeShellChecks = [ "SC2016" ];
        } )
        ( writeShellApplication {
          name = "fzf-bw-selector-tmux"; # { bwJson }: { itemUuid }
          runtimeInputs = [ jq pkgs-unstable.fzf ];
          text = ''export json="$1"; echo "$json" | jq -r '.[].id' | fzf --tmux center,70% --preview='fzf-bw-getItem {} "$json" | jq -C' '';
          excludeShellChecks = [ "SC2016" ];
        } )
      ] ;
      excludeShellChecks = [ "SC2016" ];
      # Todo: Gracefully handle Ctrl+C canceling, offer method to directly print or copy a password, implement fzf-tmux.
      # Roadmap: sops integration to decrypt passwords as late as possible, window-manager hotkey for quicker use in graphical applications.
      text = ''export json="$1"; itemJson="$(fzf-bw-getItem "$(fzf-bw-selector "$json")" "$json")"; echo -n "Username: (copied to clipboard)"; fzf-bw-getUser "$itemJson" | wl-copy; read -r; echo "Password: (copied to clipboard)"; fzf-bw-getPass "$itemJson" | wl-copy; exit 0'';
    } )
  ];
  programs.zsh.loginExtra = ''
    export $(bw unlock --passwordfile /home/joey/.bwtoken | grep export | sed 's/^\$\s//' | cut -d' ' -f2) 2>/dev/null
    function bwf { search="$1"; fzf-bw "$(bw list items --search "$search")" }
    function bwf-popup { search="$1"; kitty --title fzf-bw --override remember_window_size=no --override initial_window_width=960 --override initial_window_height=300 fzf-bw "$(bw list items --search $search)" }

  '';
} 

# function        { inputs }:           { outputs }
# fzf-bw          { bwJson }:           { none } # copies user, pass to clipboard
# fzf-bw-getItem  { itemUuid, bwJson }: { itemJson }
# fzf-bw-selector { bwJson }:           { itemUuid }
# fzf-bw-getUser  { itemJson }:  { itemUsername }
# fzf-bw-getPass  { itemJson }:  { itemPassword }
