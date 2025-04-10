{ username, ... }: let
  webBrowser = "zen.desktop";
  emailClient = "proton-mail.desktop";
  phoneHandler = "org.kde.kdeconnect.handler.desktop";
  imageViewer = "org.kde.gwenview.desktop";
  musicPlayer = "mpv.desktop";
  videoPlayer = "mpv.desktop";
  textEditor = "dev.zed.Zed.desktop";
  docViewer = "zen.desktop";
  fileManager = "org.kde.dolphin.desktop";
  terminal = "org.kde.konsole.desktop";
  archiveManager = "org.kde.ark.desktop";
in {
  home-manager.users."${username}".xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Forked from https://github.com/KDE/plasma-desktop/blob/df7412e472d3e8acd06e51b65ebb1371bfa4e1c0/kde-mimeapps.list
      # Misc
      "application/x-krita" = "${imageViewer}";
      "image/x-xcf" = "${imageViewer}";

      # Discover (disabled)
      # "x-scheme-handler/appstream" = "org.kde.discover.urlhandler.desktop";
      # "application/vnd.debian.binary-package" = "org.kde.discover.desktop";

      # Archive Manager
      "application/x-tar" = "${archiveManager}";
      "application/x-compressed-tar" = "${archiveManager}";
      "application/x-bzip-compressed-tar" = "${archiveManager}";
      "application/x-tarz" = "${archiveManager}";
      "application/x-xz-compressed-tar" = "${archiveManager}";
      "application/x-lzma-compressed-tar" = "${archiveManager}";
      "application/x-lzip-compressed-tar" = "${archiveManager}";
      "application/x-tzo" = "${archiveManager}";
      "application/x-lrzip-compressed-tar" = "${archiveManager}";
      "application/x-lz4-compressed-tar" = "${archiveManager}";
      "application/x-zstd-compressed-tar" = "${archiveManager}";
      "application/x-cd-image" = "${archiveManager}";
      "application/x-bcpio" = "${archiveManager}";
      "application/x-cpio" = "${archiveManager}";
      "application/x-cpio-compressed" = "${archiveManager}";
      "application/x-sv4cpio" = "${archiveManager}";
      "application/x-sv4crc" = "${archiveManager}";
      "application/x-source-rpm" = "${archiveManager}";
      "application/vnd.ms-cab-compressed" = "${archiveManager}";
      "application/x-xar" = "${archiveManager}";
      "application/x-iso9660-appimage" = "${archiveManager}";
      "application/x-archive" = "${archiveManager}";
      "application/vnd.rar" = "${archiveManager}";
      "application/x-rar" = "${archiveManager}";
      "application/x-7z-compressed" = "${archiveManager}";
      "application/zip" = "${archiveManager}";
      "application/x-compress" = "${archiveManager}";
      "application/gzip" = "${archiveManager}";
      "application/x-bzip" = "${archiveManager}";
      "application/x-lzma" = "${archiveManager}";
      "application/x-xz" = "${archiveManager}";
      "application/zstd" = "${archiveManager}";
      "application/x-lha" = "${archiveManager}";

      # Browser
      "x-scheme-handler/http" = "${webBrowser}";
      "x-scheme-handler/https" = "${webBrowser}";

      # Email
      "x-scheme-handler/mailto" = "${emailClient}";

      # File Manager
      "inode/directory" = "${fileManager}";

      # Geo
      "x-scheme-handler/geo" = "";

      # Image Viewer
      "image/avif" = "${imageViewer}";
      "image/gif" = "${imageViewer}";
      "image/heif" = "${imageViewer}";
      "image/jpeg" = "${imageViewer}";
      "image/jxl" = "${imageViewer}";
      "image/png" = "${imageViewer}";
      "image/bmp" = "${imageViewer}";
      "image/x-eps" = "${imageViewer}";
      "image/x-icns" = "${imageViewer}";
      "image/x-ico" = "${imageViewer}";
      "image/x-portable-bitmap" = "${imageViewer}";
      "image/x-portable-graymap" = "${imageViewer}";
      "image/x-portable-pixmap" = "${imageViewer}";
      "image/x-xbitmap" = "${imageViewer}";
      "image/x-xpixmap" = "${imageViewer}";
      "image/tiff" = "${imageViewer}";
      "image/x-psd" = "${imageViewer}";
      "image/x-webp" = "${imageViewer}";
      "image/webp" = "${imageViewer}";
      "image/x-tga" = "${imageViewer}";

      # Music Player
      "audio/aac" = "${musicPlayer}";
      "audio/mp4" = "${musicPlayer}";
      "audio/mpeg" = "${musicPlayer}";
      "audio/mpegurl" = "${musicPlayer}";
      "audio/ogg" = "${musicPlayer}";
      "audio/vnd.rn-realaudio" = "${musicPlayer}";
      "audio/vorbis" = "${musicPlayer}";
      "audio/x-flac" = "${musicPlayer}";
      "audio/x-mp3" = "${musicPlayer}";
      "audio/x-mpegurl" = "${musicPlayer}";
      "audio/x-ms-wma" = "${musicPlayer}";
      "audio/x-musepack" = "${musicPlayer}";
      "audio/x-oggflac" = "${musicPlayer}";
      "audio/x-pn-realaudio" = "${musicPlayer}";
      "audio/x-scpls" = "${musicPlayer}";
      "audio/x-speex" = "${musicPlayer}";
      "audio/x-vorbis" = "${musicPlayer}";
      "audio/x-vorbis+ogg" = "${musicPlayer}";
      "audio/x-wav" = "${musicPlayer}";

      # PDF Viewer
      "application/pdf" = "${docViewer}";

      # Phone App
      "x-scheme-handler/tel" = "${phoneHandler}";
      "x-scheme-handler/sms" = "${phoneHandler}";

      # Text Editor
      "text/plain" = "${textEditor}";
      "text/x-cmake" = "${textEditor}";
      "text/markdown" = "${textEditor}";
      "application/x-docbook+xml" = "${textEditor}";
      "application/json" = "${textEditor}";
      "application/x-yaml" = "${textEditor}";

      # Video Player
      "video/3gp" = "${videoPlayer}";
      "video/3gpp" = "${videoPlayer}";
      "video/3gpp2" = "${videoPlayer}";
      "video/avi" = "${videoPlayer}";
      "video/divx" = "${videoPlayer}";
      "video/dv" = "${videoPlayer}";
      "video/fli" = "${videoPlayer}";
      "video/flv" = "${videoPlayer}";
      "video/mp2t" = "${videoPlayer}";
      "video/mp4" = "${videoPlayer}";
      "video/mp4v-es" = "${videoPlayer}";
      "video/mpeg" = "${videoPlayer}";
      "video/msvideo" = "${videoPlayer}";
      "video/ogg" = "${videoPlayer}";
      "video/quicktime" = "${videoPlayer}";
      "video/vnd.divx" = "${videoPlayer}";
      "video/vnd.mpegurl" = "${videoPlayer}";
      "video/vnd.rn-realvideo" = "${videoPlayer}";
      "video/webm" = "${videoPlayer}";
      "video/x-avi" = "${videoPlayer}";
      "video/x-flv" = "${videoPlayer}";
      "video/x-m4v" = "${videoPlayer}";
      "video/x-matroska" = "${videoPlayer}";
      "video/x-mpeg2" = "${videoPlayer}";
      "video/x-ms-asf" = "${videoPlayer}";
      "video/x-msvideo" = "${videoPlayer}";
      "video/x-ms-wmv" = "${videoPlayer}";
      "video/x-ms-wmx" = "${videoPlayer}";
      "video/x-ogm" = "${videoPlayer}";
      "video/x-ogm+ogg" = "${videoPlayer}";
      "video/x-theora" = "${videoPlayer}";
      "video/x-theora+ogg" = "${videoPlayer}";
      "application/x-matroska" = "${videoPlayer}";
    };
  };

  xdg.mime.defaultApplications = {
    # Forked from https://github.com/KDE/plasma-desktop/blob/df7412e472d3e8acd06e51b65ebb1371bfa4e1c0/kde-mimeapps.list
    # Misc
    "application/x-krita" = "${imageViewer}";
    "image/x-xcf" = "${imageViewer}";

    # Discover (disabled)
    # "x-scheme-handler/appstream" = "org.kde.discover.urlhandler.desktop";
    # "application/vnd.debian.binary-package" = "org.kde.discover.desktop";

    # Archive Manager
    "application/x-tar" = "${archiveManager}";
    "application/x-compressed-tar" = "${archiveManager}";
    "application/x-bzip-compressed-tar" = "${archiveManager}";
    "application/x-tarz" = "${archiveManager}";
    "application/x-xz-compressed-tar" = "${archiveManager}";
    "application/x-lzma-compressed-tar" = "${archiveManager}";
    "application/x-lzip-compressed-tar" = "${archiveManager}";
    "application/x-tzo" = "${archiveManager}";
    "application/x-lrzip-compressed-tar" = "${archiveManager}";
    "application/x-lz4-compressed-tar" = "${archiveManager}";
    "application/x-zstd-compressed-tar" = "${archiveManager}";
    "application/x-cd-image" = "${archiveManager}";
    "application/x-bcpio" = "${archiveManager}";
    "application/x-cpio" = "${archiveManager}";
    "application/x-cpio-compressed" = "${archiveManager}";
    "application/x-sv4cpio" = "${archiveManager}";
    "application/x-sv4crc" = "${archiveManager}";
    "application/x-source-rpm" = "${archiveManager}";
    "application/vnd.ms-cab-compressed" = "${archiveManager}";
    "application/x-xar" = "${archiveManager}";
    "application/x-iso9660-appimage" = "${archiveManager}";
    "application/x-archive" = "${archiveManager}";
    "application/vnd.rar" = "${archiveManager}";
    "application/x-rar" = "${archiveManager}";
    "application/x-7z-compressed" = "${archiveManager}";
    "application/zip" = "${archiveManager}";
    "application/x-compress" = "${archiveManager}";
    "application/gzip" = "${archiveManager}";
    "application/x-bzip" = "${archiveManager}";
    "application/x-lzma" = "${archiveManager}";
    "application/x-xz" = "${archiveManager}";
    "application/zstd" = "${archiveManager}";
    "application/x-lha" = "${archiveManager}";

    # Browser
    "x-scheme-handler/http" = "${webBrowser}";
    "x-scheme-handler/https" = "${webBrowser}";

    # Email
    "x-scheme-handler/mailto" = "${emailClient}";

    # File Manager
    "inode/directory" = "${fileManager}";

    # Geo
    "x-scheme-handler/geo" = "";

    # Image Viewer
    "image/avif" = "${imageViewer}";
    "image/gif" = "${imageViewer}";
    "image/heif" = "${imageViewer}";
    "image/jpeg" = "${imageViewer}";
    "image/jxl" = "${imageViewer}";
    "image/png" = "${imageViewer}";
    "image/bmp" = "${imageViewer}";
    "image/x-eps" = "${imageViewer}";
    "image/x-icns" = "${imageViewer}";
    "image/x-ico" = "${imageViewer}";
    "image/x-portable-bitmap" = "${imageViewer}";
    "image/x-portable-graymap" = "${imageViewer}";
    "image/x-portable-pixmap" = "${imageViewer}";
    "image/x-xbitmap" = "${imageViewer}";
    "image/x-xpixmap" = "${imageViewer}";
    "image/tiff" = "${imageViewer}";
    "image/x-psd" = "${imageViewer}";
    "image/x-webp" = "${imageViewer}";
    "image/webp" = "${imageViewer}";
    "image/x-tga" = "${imageViewer}";

    # Music Player
    "audio/aac" = "${musicPlayer}";
    "audio/mp4" = "${musicPlayer}";
    "audio/mpeg" = "${musicPlayer}";
    "audio/mpegurl" = "${musicPlayer}";
    "audio/ogg" = "${musicPlayer}";
    "audio/vnd.rn-realaudio" = "${musicPlayer}";
    "audio/vorbis" = "${musicPlayer}";
    "audio/x-flac" = "${musicPlayer}";
    "audio/x-mp3" = "${musicPlayer}";
    "audio/x-mpegurl" = "${musicPlayer}";
    "audio/x-ms-wma" = "${musicPlayer}";
    "audio/x-musepack" = "${musicPlayer}";
    "audio/x-oggflac" = "${musicPlayer}";
    "audio/x-pn-realaudio" = "${musicPlayer}";
    "audio/x-scpls" = "${musicPlayer}";
    "audio/x-speex" = "${musicPlayer}";
    "audio/x-vorbis" = "${musicPlayer}";
    "audio/x-vorbis+ogg" = "${musicPlayer}";
    "audio/x-wav" = "${musicPlayer}";

    # PDF Viewer
    "application/pdf" = "${docViewer}";

    # Phone App
    "x-scheme-handler/tel" = "${phoneHandler}";
    "x-scheme-handler/sms" = "${phoneHandler}";

    # Text Editor
    "text/plain" = "${textEditor}";
    "text/x-cmake" = "${textEditor}";
    "text/markdown" = "${textEditor}";
    "application/x-docbook+xml" = "${textEditor}";
    "application/json" = "${textEditor}";
    "application/x-yaml" = "${textEditor}";

    # Video Player
    "video/3gp" = "${videoPlayer}";
    "video/3gpp" = "${videoPlayer}";
    "video/3gpp2" = "${videoPlayer}";
    "video/avi" = "${videoPlayer}";
    "video/divx" = "${videoPlayer}";
    "video/dv" = "${videoPlayer}";
    "video/fli" = "${videoPlayer}";
    "video/flv" = "${videoPlayer}";
    "video/mp2t" = "${videoPlayer}";
    "video/mp4" = "${videoPlayer}";
    "video/mp4v-es" = "${videoPlayer}";
    "video/mpeg" = "${videoPlayer}";
    "video/msvideo" = "${videoPlayer}";
    "video/ogg" = "${videoPlayer}";
    "video/quicktime" = "${videoPlayer}";
    "video/vnd.divx" = "${videoPlayer}";
    "video/vnd.mpegurl" = "${videoPlayer}";
    "video/vnd.rn-realvideo" = "${videoPlayer}";
    "video/webm" = "${videoPlayer}";
    "video/x-avi" = "${videoPlayer}";
    "video/x-flv" = "${videoPlayer}";
    "video/x-m4v" = "${videoPlayer}";
    "video/x-matroska" = "${videoPlayer}";
    "video/x-mpeg2" = "${videoPlayer}";
    "video/x-ms-asf" = "${videoPlayer}";
    "video/x-msvideo" = "${videoPlayer}";
    "video/x-ms-wmv" = "${videoPlayer}";
    "video/x-ms-wmx" = "${videoPlayer}";
    "video/x-ogm" = "${videoPlayer}";
    "video/x-ogm+ogg" = "${videoPlayer}";
    "video/x-theora" = "${videoPlayer}";
    "video/x-theora+ogg" = "${videoPlayer}";
    "application/x-matroska" = "${videoPlayer}";
  };
}
