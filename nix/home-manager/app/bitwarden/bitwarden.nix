{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bitwarden-cli
    jq
    wl-clipboard
    ( writeShellApplication {
      name = "fzf-bw";
      runtimeInputs = [
        jq
        fzf
        wl-clipboard
        ( writeShellApplication {
          name = "fzf-bw-preview";
          runtimeInputs = [ jq ];
          text = ''echo "$2" | jq -C --arg id "$1" '.[] | select(.id==$id) | {"user": "\(.login.username)", "password": "\(.login.password)", "name": "\(.name)"}' '';
        } )
      ];
      excludeShellChecks = [ "SC2016" ];
      text = ''export json="$1"; echo "$json" | jq -r '.[].id' | fzf --height 30% --preview='fzf-bw-preview {} "$json"' --preview-window right --disabled --border --padding=1 '';
    } )
    ( writeShellApplication {
      name = "fzf-bw-copy";
      runtimeInputs = [ jq wl-clipboard ];
      text = ''json="$1"'';
  ];
  programs.zsh.loginExtra = ''export $(bw unlock --passwordfile /home/joey/.bwtoken | grep export | sed 's/^\$\s//' | cut -d' ' -f2)'';
} 
