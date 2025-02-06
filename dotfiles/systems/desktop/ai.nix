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
      docker 
      docker-compose
      ( writeShellApplication {
        name = "ai";
        runtimeInputs = [
            libnotify
            jq
            git
        ];
        text = ''
          #!/bin/bash
        '';
      } )
    ];
  };
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/docker";
    rootless.enable = true;
    rootless.setSocketVariable = true;
  };
  users.users.${sys.username}.extraGroups = [ "docker" ];
}