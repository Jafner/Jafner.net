{ pkgs, username, ... }: {
  users.users."${username}".shell = pkgs.zsh;
  programs.zsh.enable = true;
  home-manager.users."${username}" = {
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
