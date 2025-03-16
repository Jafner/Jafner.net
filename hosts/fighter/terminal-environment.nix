{ sys, pkgs, ... }: {
  users.users."${sys.username}".shell = pkgs.bash;
  home-manager.users."${sys.username}" = {
    home.packages = with pkgs; [
      bat
      fd
      fastfetch
      fzf
      jq
      tree
      nethogs
      pinentry-all
      ffmpeg-full
      libva-utils
    ];

    programs.btop = {
      enable = true;
      package = pkgs.btop-rocm;
      settings = {
        color_theme = "stylix";
        theme_background = true;
        update_ms = 500;
      };
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
      shell = "${pkgs.bash.shellPath}";
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
  };
}
