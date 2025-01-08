{ pkgs, ... }: {
  imports = [
    ../../modules/services/ssh.nix
    ../../modules/services/flatpak.nix
    ../../modules/services/minecraft-server.nix
  ];
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
}