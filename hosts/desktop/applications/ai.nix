{ pkgs, sys, ... }: {
  services.ollama = {
    enable = true;
    port = 11434;
    host = "127.0.0.1";
    home = "/var/lib/ollama";
    group = "users";
    models = "/var/lib/ollama/models";
    loadModels = [ "llama3.2:3b" "llama3.1:8b" "codellama:13b" ];
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "11.0.0";
    acceleration = "rocm";
  };
  home-manager.users."${sys.username}" = {
    home.packages = with pkgs; [ 
      lmstudio 
      ollama-rocm
      ( writeShellApplication {
        name = "ollama-chat";
        runtimeInputs = [
          libnotify
        ];
        text = ''
          #!/bin/bash

          # shellcheck disable=SC2034
          DEFAULT_MODEL="llama3.2:3b"

          MODEL=''$''\{1:-DEFAULT_MODEL}

          echo "Loading model $MODEL"
          ${pkgs.ollama-rocm}/bin/ollama run "$MODEL" ""
          echo "Finished loading $MODEL"

          ${pkgs.ollama-rocm}/bin/ollama run "$MODEL"

          echo "Unloading model $MODEL"
          ${pkgs.ollama-rocm}/bin/ollama stop "$MODEL"
        '';
      } )
    ];
    xdg.desktopEntries = {
      ollama = {
        exec = "ollama-wrapped";
        icon = "/home/${sys.username}/.icons/custom/ollama.png";
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
}