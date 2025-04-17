{ pkgs, username, ... }:
{
  services.ollama = {
    enable = true;
    port = 11434;
    host = "127.0.0.1";
    home = "/var/lib/ollama";
    group = "users";
    models = "/var/lib/ollama/models";
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "11.0.0";
    acceleration = "rocm";
  };
  home-manager.users."${username}" = {
    home.packages = with pkgs; [
      ollama-rocm
    ];
  };
}
