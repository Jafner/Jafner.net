{ pkgs
, config
, ...
}:
let
  cfg = config.services.ollama-rocm;
in
{
  options = with pkgs.lib; {
    services.ollama-rocm = {
      enable = mkEnableOption "ollama-rocm";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
      chatModel = mkOption {
        type = types.str;
        default = null;
        example = "gemma3:1b";
      };
      loadModels = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Download these models using `ollama pull` as soon as `ollama.service` has started.
          This creates a systemd unit `ollama-model-loader.service`.

          Search for models of your choice from: https://ollama.com/library
        '';
      };
      rocmOverrideGfx = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "10.3.0";
        description = ''
          Override what rocm will detect your gpu model as.
          For example, if you have an RX 5700 XT, try setting this to `"10.1.0"` (gfx 1010).

          This sets the value of `HSA_OVERRIDE_GFX_VERSION`. See [ollama's docs](
          https://github.com/ollama/ollama/blob/main/docs/gpu.md#amd-radeon
          ) for details.
        '';
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      port = 11434;
      host = "127.0.0.1";
      home = "/var/lib/ollama";
      group = "users";
      models = "/var/lib/ollama/models";
      loadModels = cfg.loadModels;
      package = pkgs.ollama-rocm;
      rocmOverrideGfx = cfg.rocmOverrideGfx;
      acceleration = "rocm";
    };
    home-manager.users."${cfg.username}" = {
      home.packages = with pkgs; [
        ollama-rocm
        (writeShellApplication {
          name = "ollama-chat";
          runtimeInputs = [
            libnotify
          ];
          text = ''
            #!/bin/bash

            # shellcheck disable=SC2034
            DEFAULT_MODEL="${cfg.chatModel}"

            MODEL=''$''\{1:-DEFAULT_MODEL}

            echo "Loading model $MODEL"
            ${pkgs.ollama-rocm}/bin/ollama run "$MODEL" ""
            echo "Finished loading $MODEL"

            ${pkgs.ollama-rocm}/bin/ollama run "$MODEL"

            echo "Unloading model $MODEL"
            ${pkgs.ollama-rocm}/bin/ollama stop "$MODEL"
          '';
        })
      ];
      xdg.desktopEntries = {
        ollama = {
          exec = "ollama-wrapped";
          icon = "/home/${cfg.username}/.icons/custom/ollama.png";
          name = "AI Chat";
          categories = [ "Utility" ];
          type = "Application";
        };
      };
      home.file = {
        "ollama.png" = {
          target = ".icons/custom/ollama.png";
          source = pkgs.fetchurl {
            url = "https://ollama.com/public/icon-64x64.png";
            sha256 = "sha256-jzjt+wB9e3TwPSrXpXwCPapngDF5WtEYNt9ZOXB2Sgs=";
          };
        };
      };
    };
  };
}
