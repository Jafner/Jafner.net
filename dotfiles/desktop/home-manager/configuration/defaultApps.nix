{ ... }: {
  xdg.mimeApps = let
    webBrowser = "zen.desktop";
    emailClient = "proton-mail.desktop";

    imageViewer = "org.kde.gwenview.desktop";
    musicPlayer = "vlc.desktop";
    videoPlayer = "vlc.desktop";

    textEditor = "dev.zed.Zed.desktop";
    docViewer = "zen.desktop";

    fileManager = "org.kde.dolphin.desktop";
    terminal = "org.kde.konsole.desktop";
    archiveManager = "org.kde.ark.desktop";
  in {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "${webBrowser}";
      "x-scheme-handler/https" = "${webBrowser}";
      "x-scheme-handler/about" = "${webBrowser}";
      "x-scheme-handler/unknown" = "${webBrowser}";
      "application/json" = "${textEditor}";
      "application/pdf" = "${webBrowser}";
      "application/vnd.apple.keynote" = "${textEditor}";
      "application/vnd.ms-publisher" = "${textEditor}";
      "application/x-desktop" = "${textEditor}";
      "application/x-executable" = "${textEditor}";
      "text/css" = "${textEditor}";
      "text/html" = "${textEditor}";
      "text/plain" = "${textEditor}";
      "video/mp4" = "${videoPlayer}";
      "video/x-matroska" = "${videoPlayer}";
    };
    associations.added = {
    };
  };
}
