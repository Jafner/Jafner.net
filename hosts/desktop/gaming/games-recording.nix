{ pkgs, sys, ... }: {
  home-manager.users."${sys.username}" = {
    home.packages = with pkgs; [ 
      losslesscut-bin
      ffmpeg-full
      libnotify
      ( writers.writePython3Bin "obs-toggle-recording" {
        libraries = [
          ( python312Packages.buildPythonPackage {
            pname = "obsws_python";
            version = "1.7.0";
            src = fetchurl {
              url = "https://files.pythonhosted.org/packages/22/29/dcb5286c9301eee8b72aee1e997761fb2cca9bf963fcd373acdfca353af3/obsws_python-1.7.0-py3-none-any.whl";
              sha256 = "0jvqfvqgvqjsv0jsddj51m4wrinbrc2gbymmnmv9kfarfj7ly7g7";
            };
            format = "wheel";
            doCheck = false;
            buildInputs = [];
            checkInputs = [];
            nativeBuildInputs = [];
            propagatedBuildInputs = [
              ( python312Packages.buildPythonPackage {
                pname = "tomli";
                version = "2.0.2";
                src = fetchurl {
                  url = "https://files.pythonhosted.org/packages/cf/db/ce8eda256fa131af12e0a76d481711abe4681b6923c27efb9a255c9e4594/tomli-2.0.2-py3-none-any.whl";
                  sha256 = "0f5ar8vfq7lkydj19am5ymxg11d00ql0kv5hj3v07lskbi429gif";
                };
                format = "wheel";
                doCheck = false;
                buildInputs = [];
                checkInputs = [];
                nativeBuildInputs = [];
                propagatedBuildInputs = [];
              } )
              ( python312Packages.buildPythonPackage {
                pname = "websocket-client";
                version = "1.8.0";
                src = fetchurl {
                  url = "https://files.pythonhosted.org/packages/5a/84/44687a29792a70e111c5c477230a72c4b957d88d16141199bf9acb7537a3/websocket_client-1.8.0-py3-none-any.whl";
                  sha256 = "09m5pwwi4bbwdv2vdhlc5k0737kskhnxyb5j17l9ii7mjz4lrd0p";
                };
                format = "wheel";
                doCheck = false;
                buildInputs = [];
                checkInputs = [];
                nativeBuildInputs = [];
                propagatedBuildInputs = [];
              } )
            ];
          } )
        ];
        } ''
          import obsws_python as obs
          client = obs.ReqClient(host='localhost', port=4455)
          recording_status = client.get_record_status()
          active = recording_status.output_active
          paused = recording_status.output_paused

          if not active:
              client.start_record()
          else:
              client.toggle_record_pause()
        '' )
    ];
    home.file = { # Note: Will need to be integrated with any file manager that isn't dolphin
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
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-vaapi
        obs-vkcapture
        input-overlay
        wlrobs
      ];
    };
  };
  
}