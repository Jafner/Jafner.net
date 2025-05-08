{ pkgs
, config
, ...
}:
let
  cfg = config.modules.plasma6;
in
{
  imports = [ ../default-applications.nix ];
  options = with pkgs.lib; {
    modules.plasma6 = {
      enable = mkEnableOption "plasma6";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    modules.default-applications = {
      enable = true;
      username = cfg.username;
      webBrowser = "zen.desktop";
      emailClient = "proton-mail.desktop";
      phoneHandler = "org.kde.kdeconnect.handler.desktop";
      imageViewer = "org.kde.gwenview.desktop";
      musicPlayer = "vlc.desktop";
      videoPlayer = "vlc.desktop";
      textEditor = "dev.zed.Zed.desktop";
      docViewer = "zen.desktop";
      fileManager = "org.kde.dolphin.desktop";
      terminal = "org.kde.konsole.desktop";
      archiveManager = "org.kde.ark.desktop";
    };

    programs.kdeconnect.enable = true;
    programs.xwayland.enable = true;
    programs.partition-manager.enable = true;

    home-manager.users."${cfg.username}" = {
      # TODO: Identify which packages we would only use with Plasma6 (vs. Hyrpland)
      home.packages = with pkgs; [
        kdePackages.kcalc
        kdePackages.filelight
        wl-clipboard
        wl-color-picker
        dotool
      ];
      home.file = {
        # Note: Will need to be integrated with any file manager that isn't dolphin
        "run-video-script" = {
          target = ".local/share/kio/servicemenus/run-video-script.desktop";
          text = ''
            [Desktop Entry]
            Type=Service
            MimeType=video/*;
            Actions=convertForDiscord;convertLossless;sendToZipline;sendToCloudflare;sendToZiplineAndCloudflare;
            X-KDE-Submenu=Run video script...

            [Desktop Action convertForDiscord]
            Name=Convert for Discord
            Icon=video-mp4
            Exec=kitty convert-for-discord "%f"

            [Desktop Action convertLossless]
            Name=Convert losslessly to MP4
            Icon=video-mp4
            Exec=kitty convert-lossless "%f"

            [Desktop Action sendToZipline]
            Name=Send to Zipline
            Icon=video-mp4
            Exec=send-to-zipline "%f" | wl-copy

            [Desktop Action sendToCloudflare]
            Name=Send to Cloudflare
            Icon=video-mp4
            Exec=send-to-cloudflare "%f" | wl-copy

            [Desktop Action sendToZiplineAndCloudflare]
            Name=Send to Zipline and Cloudflare
            Icon=video-mp4
            Exec=send-to-zipline-and-cloudflare "%f" | wl-copy
          '';
        };
      };
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
      ];
    };

    services = {
      desktopManager.plasma6.enable = true;
      displayManager = {
        enable = true;
        defaultSession = "plasma";
        autoLogin.enable = true;
        autoLogin.user = "${cfg.username}";
        sddm = {
          enable = true;
          autoNumlock = true;
          wayland.enable = true;
          wayland.compositor = "kwin";
        };
      };
      xserver = {
        enable = true;
        videoDrivers = [ "amdgpu" ];
        excludePackages = [ pkgs.xterm ];
        xkb = {
          layout = "us";
          variant = "";
        };
      };
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      kate
      okular
      discover
    ];

    systemd.services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };
}
