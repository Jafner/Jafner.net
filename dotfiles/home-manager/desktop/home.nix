{ vars, ... }:
{
  imports = [
    ./configuration/stylix.nix
    ./configuration/git.nix
    ./configuration/keys.nix
    ./configuration/defaultApps.nix
    ./configuration/mangohud.nix
    ./apps/browser.nix
    ./apps/discord.nix
    ./apps/obs-studio.nix
    ./apps/terminal.nix
    ./apps/vscode.nix
    ./apps/iac-tools.nix
    ./apps/minecraft.nix
    ./apps/multimedia.nix
    ./apps/obsidian.nix
    ./apps/spotify.nix
    ./apps/systeminfo.nix
    ./apps/password-manager.nix
    ./apps/email.nix
    ./apps/emulators.nix
    ./apps/ai.nix
    ./services/flatpak.nix
    ./services/kdeconnect.nix
    ./services/nextcloud.nix
    ./services/protonmail.nix
    ./services/goxlr-utility.nix
    ./scripts/ffmpeg.nix
    ./scripts/kitty-popup.nix
    ./scripts/nixos.nix
    ./scripts/obs-toggle-recording.nix
  ];

  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    remotes = [
      { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
    ];
  };

  home.enableNixpkgsReleaseCheck = false;
  home.preferXdgDirectories = true;
  home.username = "${vars.user.username}";
  home.homeDirectory = "/home/${vars.user.username}";
  home.stateVersion = "24.11";
  home.file = {
    "Music" = {
      enable = false;
      target = "Music/";
    };
  };
  home.sessionVariables = { };
  programs.home-manager.enable = true;
  xdg.systemDirs.data = [
    "/usr/share"
  ];
}
