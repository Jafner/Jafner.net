{ pkgs, ... }:
{
  ## OBS-Studio
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
      obs-vkcapture
      input-overlay
    ];
  };
}