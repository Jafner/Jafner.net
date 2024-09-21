{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bitwarden-cli
    jq
    wl-clipboard
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
          runtimeInputs = [ jq fzf ];
          text = ''export json="$1"; echo "$json" | jq -r '.[].id' | fzf --height 30% --preview='fzf-bw-getItem {} "$json" | jq -C' --preview-window right --disabled --border --padding=1'';
          excludeShellChecks = [ "SC2016" ];
        } )
      ] ;
      excludeShellChecks = [ "SC2016" ];
      text = ''export json="$1"; itemJson="$(fzf-bw-getItem "$(fzf-bw-selector "$json")" "$json")"; echo "Username: (copied to clipboard)"; fzf-bw-getUser "$itemJson" | wl-copy; read -r; echo "Password: (copied to clipboard)"; fzf-bw-getPass "$itemJson" | wl-copy'';
    } )
     
  ];
  programs.zsh.loginExtra = ''
    export $(bw unlock --passwordfile /home/joey/.bwtoken | grep export | sed 's/^\$\s//' | cut -d' ' -f2) 
    function bwf { search="$1"; fzf-bw "$(bw list items --search "$search")" }
  '';
} 

# function        { inputs }:           { outputs }
# fzf-bw          { bwJson }:           { none } # copies user, pass to clipboard
# fzf-bw-getItem  { itemUuid, bwJson }: { itemJson }
# fzf-bw-selector { bwJson }:           { itemUuid }
# fzf-bw-getUser  { itemJson }:  { itemUsername }
# fzf-bw-getPass  { itemJson }:  { itemPassword }
