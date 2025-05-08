{ pkgs
, lib
, username
, ...
}: {
  home-manager.users."${username}" = {
    programs.zsh.envExtra = ''
      OPENROUTER_API_KEY=$(cat /home/joey/.keys/openrouter/zed)
    '';
    home.packages = with pkgs; [
      nixd
      sops
    ];

    programs.zed-editor = {
      # https://mynixos.com/home-manager/options/programs.zed-editor
      enable = true;
      package = pkgs.zed-editor_git;
      extensions = [
        "Nix"
        "Catppuccin"
        "mcp-server-github"
      ];
      userSettings = {
        tab_size = 2;
        languages."Nix" = {
          "show_completion_documentation" = true;
          "show_completions_on_input" = true;
          "show_edit_predictions" = true;
          "language_servers" = [
            "!nil"
            "nixd"
          ];
        };
        theme = lib.mkDefault {
          mode = "system";
          dark = "Catppuccin Mocha";
          light = "Catppuccin Mocha";
        };
        terminal = {
          shell = {
            program = "zsh";
          };
        };
        lsp = {
          "nixd" = {
            nixpkgs.expr = "import (builtins.getFlake \"/home/joey/Git/Jafner.net\").inputs.nixpkgs { } ";
            formatting.command = "nixfmt";
            options = {
              nixos.expr = "(builtins.getFlake \"/home/joey/Git/Jafner.net\").nixosConfigurations.desktop.options";
            };
          };
        };
        edit_predictions = {
          mode = "eager";
        };
        language_models = {
          "openai" = {
            version = "1";
            api_url = "https://openrouter.ai/api/v1";
            available_models = [
              {
                name = "deepseek/deepseek-r1:free";
                display_name = "DeepSeek R1";
                max_tokens = 163840;
                max_output_tokens = 163840;
              }
              {
                name = "deepseek/deepseek-chat-v3-0324:free";
                display_name = "DeepSeek V3";
                max_tokens = 163840;
                max_output_tokens = 163840;
              }
            ];
          };
        };
        assistant = {
          enabled = true;
          version = "2";
          default_model = {
            provider = "openai";
            model = "deepseek/deepseek-chat-v3-0324:free";
          };
        };
      };
    };
  };
}
