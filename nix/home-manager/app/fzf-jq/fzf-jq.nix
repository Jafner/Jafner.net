{ pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs; [
    jq
    wl-clipboard
    ( writeShellApplication {
      name = "fzf-jq"; # { bwJson }: { itemPreviewJson }
      runtimeInputs = [ wl-clipboard jq ] ;
      excludeShellChecks = [ "SC2016" ];
      text = ''export json="$1"; itemJson="$(fzf-bw-getItem "$(fzf-bw-selector "$json")" "$json")"; echo -n "Username: (copied to clipboard)"; fzf-bw-getUser "$itemJson" | wl-copy; read -r; echo "Password: (copied to clipboard)"; fzf-bw-getPass "$itemJson" | wl-copy; exit 0'';
    } )
  ];
  programs.zsh.loginExtra = '' '';
} 

# fzf-jq          { jsonBody, searchByExp, itemPreviewExp }: {  } 
#  summary: allows the user to interactively browse json objects
#  details: takes a json object containing a list of objects, a jq expression which returns the list of objects on one line each, and a jq expression which returns only the object currently selected

