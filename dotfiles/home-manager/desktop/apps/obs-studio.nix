{ pkgs, pkgs-unstable, ... }: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
      obs-vkcapture
      input-overlay
      wlrobs
    ];
    package = pkgs.writeShellScriptBin "obs" ''
        #!/bin/sh
        ${pkgs-unstable.nixgl.nixVulkanIntel}/bin/nixVulkanIntel ${pkgs-unstable.obs-studio}/bin/obs "$@"
    '';
  };
  xdg.desktopEntries."obs" = {
    name = "OBS Studio";
    genericName = "Streaming/Recording Software";
    type = "Application";
    comment = "Free and Open Source Streaming/Recording Software";
    categories = [ "AudioVideo" "Recorder" ];
    exec = "nixGL obs";
    icon = pkgs.fetchurl {
      url = "https://upload.wikimedia.org/wikipedia/commons/d/d3/OBS_Studio_Logo.svg";
      sha256 = "sha256-7kTlDSmknwahRiiSPZPU7Fs49q2ViSIPsI/1s8z8mIs=";
    };
    terminal = false;
    settings = {
      StartupNotify = "true";
      StartupWMClass = "obs";
    };
  };
}
