{ sys, pkgs, ... }: {
  home-manager.users."${sys.username}" = {
    home.packages = with pkgs; [ 
      fd
      fastfetch
      jq
      tree
      pinentry-all
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