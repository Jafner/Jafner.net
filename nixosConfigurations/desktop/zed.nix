{ pkgs, username, ... }:
{
  home-manager.users."${username}" = {
    programs.zsh.envExtra = ''
      OPENROUTER_API_KEY=$(rbw get openrouter --field="Zed Assistant")
    '';
    home.packages = with pkgs; [
      nixd
      sops
    ];
    programs.zed-editor = {
      # https://mynixos.com/home-manager/options/programs.zed-editor
      enable = true;
      extensions = [
        "Nix"
        "Catppuccin"
        "mcp-server-github"
      ];
      userSettings = {
        tab_size = 2;
        languages."Nix" = {
          "language_servers" = [
            "!nil"
            "nixd"
          ];
        };
        theme = {
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
        context_servers = {
          "mcp-server-github" = {
            settings = {
              github_personal_access_token = "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";
            };
          };
        };
        language_models = {
          "openai" = {
            version = "1";
            api_url = "https://openrouter.ai/api/v1";
            available_models = [
              {
                name = "deepseek/deepseek-chat-v3-0324:free";
                display_name = "DeepSeek";
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
