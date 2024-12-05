{ pkgs, pkgs-unstable, inputs, vars, ... }:
{
  imports = [
    ./apps/browser.nix
    ./apps/discord.nix
    ./apps/git.nix
    ./apps/obs-studio.nix
    ./apps/terminal.nix
    ./apps/vscode.nix
    ./apps/iac-tools.nix
    ./apps/spotify.nix
    ./hardware/goxlr.nix
  ];


  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    remotes = [
      { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
    ];
    packages = [
      "io.missioncenter.MissionCenter/x86_64/stable"
      "no.mifi.losslesscut/x86_64/stable"
      "org.prismlauncher.PrismLauncher/x86_64/stable"
      "org.videolan.VLC/x86_64/stable"
    ];
  };

  home.enableNixpkgsReleaseCheck = false;
  home.preferXdgDirectories = true;
  home.username = "${vars.user.username}";
  home.homeDirectory = "/home/${vars.user.username}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    flatpak
    fastfetch
    nixd
    kdePackages.kdeconnect-kde
    vlc
    #ollama
    #protonup-ng
    #protonmail-bridge-gui
    #obsidian
    #gamepad-tool
    #linuxKernel.packages.linux_6_11.xpadneo
  ];
  home.file = { };
  home.sessionVariables = { };
  programs.home-manager.enable = true;
  xdg.systemDirs.data = [
    "/usr/share"
  ];
}
