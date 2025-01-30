{ sys, pkgs }: {
  users.users."${sys.username}".shell = pkgs.${sys.shellPackage};
  programs."${sys.shellPackage}".enable = true;
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
    ] ++ [
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
            FLAKE_URI="git+https://gitea.jafner.tools/Jafner/Jafner.net?dir=dotfiles#fighter"

            rebuild() {
              notify-send "Nixos: Beginning rebuild"
              sudo nixos-rebuild switch \
                  --flake "$FLAKE_URI" \
                  --impure \
                  --show-trace &&\
              notify-send "Nixos: Rebuilt successfully"
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
            rebuild) rebuild && finish;;
            clean) garbageCollect && finish;;
            ls) listGenerations;;
            where) where "$2";;
            *) error "Unrecognized subcommand $1";;
            esac
        '';
      } )
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
      shell = "${pkgs.${sys.shellPackage}.shellPath}";
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
