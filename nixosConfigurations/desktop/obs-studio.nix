{ pkgs
, username
, ...
}: {
  home-manager.users."${username}" = {
    home.packages = with pkgs; [
      (
        writers.writePython3Bin "obs-toggle-recording"
          {
            libraries = [
              (python312Packages.buildPythonPackage {
                pname = "obsws_python";
                version = "1.7.0";
                src = fetchurl {
                  url = "https://files.pythonhosted.org/packages/22/29/dcb5286c9301eee8b72aee1e997761fb2cca9bf963fcd373acdfca353af3/obsws_python-1.7.0-py3-none-any.whl";
                  sha256 = "0jvqfvqgvqjsv0jsddj51m4wrinbrc2gbymmnmv9kfarfj7ly7g7";
                };
                format = "wheel";
                doCheck = false;
                buildInputs = [ ];
                checkInputs = [ ];
                nativeBuildInputs = [ ];
                propagatedBuildInputs = [
                  (python312Packages.buildPythonPackage {
                    pname = "tomli";
                    version = "2.0.2";
                    src = fetchurl {
                      url = "https://files.pythonhosted.org/packages/cf/db/ce8eda256fa131af12e0a76d481711abe4681b6923c27efb9a255c9e4594/tomli-2.0.2-py3-none-any.whl";
                      sha256 = "0f5ar8vfq7lkydj19am5ymxg11d00ql0kv5hj3v07lskbi429gif";
                    };
                    format = "wheel";
                    doCheck = false;
                    buildInputs = [ ];
                    checkInputs = [ ];
                    nativeBuildInputs = [ ];
                    propagatedBuildInputs = [ ];
                  })
                  (python312Packages.buildPythonPackage {
                    pname = "websocket-client";
                    version = "1.8.0";
                    src = fetchurl {
                      url = "https://files.pythonhosted.org/packages/5a/84/44687a29792a70e111c5c477230a72c4b957d88d16141199bf9acb7537a3/websocket_client-1.8.0-py3-none-any.whl";
                      sha256 = "09m5pwwi4bbwdv2vdhlc5k0737kskhnxyb5j17l9ii7mjz4lrd0p";
                    };
                    format = "wheel";
                    doCheck = false;
                    buildInputs = [ ];
                    checkInputs = [ ];
                    nativeBuildInputs = [ ];
                    propagatedBuildInputs = [ ];
                  })
                ];
              })
            ];
          }
          ''
            import obsws_python as obs
            client = obs.ReqClient(host='localhost', port=4455)
            recording_status = client.get_record_status()
            active = recording_status.output_active
            paused = recording_status.output_paused

            if not active:
                client.start_record()
            else:
                client.toggle_record_pause()
          ''
      )
    ];
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-vaapi
        obs-vkcapture
        wlrobs
      ];
    };
    home.file."theme" = {
      recursive = true;
      source = ./custom-obs-theme/Custom.obt;
      target = ".config/obs-studio/themes/Custom.obt";
    };
  };

  # Required for use of Virtual Camera
  boot.extraModulePackages = [ pkgs.linuxPackages_cachyos.v4l2loopback ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;
}
