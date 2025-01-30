{ pkgs, sys, inputs, ... }: {
  imports = [
      ./defaultApplications.nix
      ../../modules/programs/spotify.nix
  ];
  programs.kdeconnect.enable = true;
  programs.xwayland.enable = true;
  programs.steam.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  programs.partition-manager.enable = true;

  home-manager.users."${sys.username}" = {
    home.packages = with pkgs;
    [ # Productivity
      obsidian
      libreoffice-qt6
      kdePackages.kcalc
    ] ++ [ # Browser(s)
      inputs.zen-browser.packages."${sys.arch}".default
    ] ++ [ # Multimedia viewers
      vlc
    ] ++ [ # Messaging tools
      protonmail-desktop
      protonmail-bridge-gui
      vesktop
    ] ++ [ # Gaming
      prismlauncher
      dolphin-emu
      mgba
      desmume
      lutris-unwrapped
      protonup-ng
      vulkan-tools
    ] ++ [ # System utilities
      rofi-rbw-wayland
      wl-clipboard
      wl-color-picker
      dotool
      nixd
      sops
    ] ++ [ # Media creation tools
      losslesscut-bin
      ffmpeg-full
      libnotify
      ( writeShellApplication {
        name = "convert-for-discord"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
        runtimeInputs = [
          libnotify
          ffmpeg-full
        ];
        text = ''
          #!/bin/bash

          INPUT_FILE=$(realpath "$1")
          FILE_PATH=$(dirname "$INPUT_FILE")
          FILE_NAME=$(basename "$INPUT_FILE")
          #FILE_EXT="''$''\{FILE_NAME##*.}"
          FILE_NAME="''$''\{FILE_NAME%.*}"
          OUTFILE="$FILE_PATH/$FILE_NAME.mp4"

          # Actual transcoding happens here:
          notify-send -t 2000 "Transcode starting" "$FILE_NAME"
          ffmpeg -hide_banner -vaapi_device /dev/dri/renderD128 -i "$INPUT_FILE" -map 0 -vf 'format=nv12,scale=-1:720,hwupload' -c:v h264_vaapi -b:v 8M -c:a copy -r 30 "$OUTFILE"
          notify-send -t 4000 "Transcode complete" "$FILE_NAME"
        '';
      } )
      ( writeShellApplication {
        name = "convert-lossless"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
        runtimeInputs = [
          libnotify
          ffmpeg-full
        ];
        text = ''
          #!/bin/bash

          INPUT_FILE="''$''\{1:-INPUT_FILE}"
          INPUT_FILE=$(realpath "$INPUT_FILE")
          FILE_PATH=$(dirname "$INPUT_FILE")
          FILE_NAME=$(basename "$INPUT_FILE")
          #FILE_EXT="''$''\{FILE_NAME##*.}"
          FILE_NAME="''$''\{FILE_NAME%.*}"
          OUTFILE="$FILE_PATH/$FILE_NAME.mp4"

          # Actual transcoding happens here:
          notify-send -t 2000 "Transcode starting" "$FILE_NAME"
          ffmpeg -hide_banner -vaapi_device /dev/dri/renderD128 -i "$INPUT_FILE" -movflags faststart -map 0 -c:v copy -c:a copy "$OUTFILE"
          notify-send -t 4000 "Transcode complete" "$FILE_NAME"
        '';
      } )
      ( writeShellApplication {
        name = "send-to-zipline"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
        runtimeInputs = [
          libnotify
          curl
          jq
          wl-clipboard
          wl-clip-persist
        ];
        text = ''
          #!/bin/bash

          INPUT_FILE="''$''\{1:-INPUT_FILE}"
          INPUT_FILE=$(realpath "$INPUT_FILE")
          FILE_NAME=$(basename "$INPUT_FILE")
          FILE_NAME="''$''\{FILE_NAME%.*}"

          ZIPLINE_HOST_ROOT=https://zipline.jafner.net
          TOKEN=$(cat ~/.zipline-auth)
          RESPONSE=$(curl \
              --header "authorization: $TOKEN" \
              $ZIPLINE_HOST_ROOT/api/upload -F "file=@$INPUT_FILE" \
              --header "Content-Type: multipart/form-data" \
              --header "Format: name" \
              --header "Embed: true" \
              --header "Original-Name: true")
          LINK=$(echo "$RESPONSE" | jq -r .'files[0]')
          notify-send -t 4000 "Zipline - Upload complete." "Link copied to clipboard: $LINK"
          echo "[$FILE_NAME]($LINK)" 
        '';
      } )
      ( writeShellApplication {
        name = "send-to-cloudflare"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
        runtimeInputs = [
          libnotify
          curl
          jq
          wl-clipboard
          wl-clip-persist
        ];
        text = ''
          #!/bin/bash

          INPUT_FILE="''$''\{1:-INPUT_FILE}" 
          INPUT_FILE=$(realpath "$INPUT_FILE")
          FILE_NAME=$(basename "$INPUT_FILE")
          FILE_NAME="''$''\{FILE_NAME%.*}"

          CF_TOKEN="$(cat ~/.cf-auth)"
          CF_ID="$(cat ~/.cf-id)"

          notify-send -t 2000 "Cloudflare - Beginning upload."

          # shellcheck disable=SC2086
          RESPONSE=$(curl -X POST \
            --header "Authorization: Bearer $CF_TOKEN" \
            --form "file=@$INPUT_FILE" \
            https://api.cloudflare.com/client/v4/accounts/$CF_ID/stream 
          )
          LINK=$(echo "$RESPONSE" | jq -r '.result.preview')
          notify-send -t 4000 "Cloudflare - Upload complete." "Link copied to clipboard: $LINK"
          echo "[$FILE_NAME]($LINK)" 
        '';
      } )
      ( writeShellApplication {
        name = "send-to-zipline-and-cloudflare"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
        runtimeInputs = [
          libnotify
          curl
          jq
          wl-clipboard
          wl-clip-persist
        ];
        text = ''
          #!/bin/bash

          INPUT_FILE="''$''\{1:-INPUT_FILE}" 
          INPUT_FILE=$(realpath "$INPUT_FILE")
          FILE_NAME=$(basename "$INPUT_FILE")
          FILE_NAME="''$''\{FILE_NAME%.*}"

          ZIPLINE_HOST_ROOT=https://zipline.jafner.net
          TOKEN=$(cat ~/.zipline-auth)

          notify-send -t 2000 "Zipline and Cloudflare - Beginning upload."
          RESPONSE=$(curl \
              --header "authorization: $TOKEN" \
              $ZIPLINE_HOST_ROOT/api/upload -F "file=@$INPUT_FILE" \
              --header "Content-Type: multipart/form-data" \
              --header "Format: name" \
              --header "Embed: true" \
              --header "Original-Name: true")
          LINK=$(echo "$RESPONSE" | jq -r .'files[0]' | sed 's/\/u\//\/r\//')

          CF_TOKEN="$(cat ~/.cf-auth)"
          CF_ID="$(cat ~/.cf-id)"

          # shellcheck disable=SC2086
          RESPONSE=$(curl -X POST \
            --header "Authorization: Bearer $CF_TOKEN" \
            --data "{\"url\":\"$LINK\",\"meta\":{\"name\":\"$FILE_NAME\"}}" \
            https://api.cloudflare.com/client/v4/accounts/$CF_ID/stream/copy
          )
          LINK=$(echo "$RESPONSE" | jq -r '.result.preview')
          notify-send -t 4000 "Zipline and Cloudflare - Upload complete." "Link copied to clipboard: $LINK"
          echo "[$FILE_NAME]($LINK)" 
        '';
      } )
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
              }
            )
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
    ] ++ [ # Other applications
      ollama-rocm
      ( writeShellApplication {
        name = "ollama-chat";
        runtimeInputs = [
          libnotify
        ];
        text = ''
          #!/bin/bash

          # shellcheck disable=SC2034
          DEFAULT_MODEL="llama3.2:3b"

          MODEL=''$''\{1:-DEFAULT_MODEL}

          echo "Loading model $MODEL"
          ${pkgs.ollama-rocm}/bin/ollama run "$MODEL" ""
          echo "Finished loading $MODEL"

          ${pkgs.ollama-rocm}/bin/ollama run "$MODEL"

          echo "Unloading model $MODEL"
          ${pkgs.ollama-rocm}/bin/ollama stop "$MODEL"
        '';
      } )
    ];
    programs.chromium.enable = true;
    programs.firefox.enable = true;
    programs.wofi.enable = true;
    programs.zed-editor = {
      # https://mynixos.com/home-manager/options/programs.zed-editor
      enable = true;
      extensions = [ "Nix" "Catppuccin" ];
      userSettings = {
        languages."Nix"."language_servers" = [ "!nil" "nixd" ];
        theme = {
          mode = "system";
          dark = "Catppuccin Mocha";
          light = "Catppuccin Mocha";
        };
        terminal = {
          # using bash as a workaround.
          # zsh in the integrated terminal misbehaves.
          # seems to render multiple characters with every keystroke (incl. backspace)
          shell = { program = "bash"; };
        };
      };
    };
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        adzero.vscode-sievehighlight
      ];
      userSettings = {
        "editor.fontFamily" = pkgs.lib.mkDefault "'DejaVu Sans Mono'"; # Potentially collides with Stylix
        "nix.serverPath" = "nixd";
        "nix.enableLanguageServer" = true;
        "explorer.confirmDragAndDrop" = false;
        "explorer.confirmDelete" = false;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "security.workspace.trust.untrustedFiles" = "open";
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "terminal.integrated.fontFamily" = pkgs.lib.mkDefault "'DejaVu Sans Mono'"; # Potentially collides with Stylix
        "terminal.integrated.profiles.linux.zsh.path" = "/usr/bin/zsh";
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
    programs.rbw = {
      enable = true;
      settings = {
        base_url = "https://bitwarden.jafner.tools";
        email = "jafner425@gmail.com";
        lock_timeout = 2592000;
        pinentry = pkgs.pinentry-qt;
      };
    };
    programs.mangohud = {
      enable = true;
      settingsPerApplication = {
        wine-Overwatch = {
          fps = false;
          fps_color_change = false;
          fps_text = "";
          fps_value = "59,239";
          fps_metrics = false;
          frame_timing = true;
          frame_timing_detailed = false;
          dynamic_frame_timing = true;
          frametime = false;
          histogram = true;
          show_fps_limit = false;
          gamemode = false;
          present_mode = false;
          vulkan_driver = false;
          engine_version = false;
          engine_short_names = false;
          exec_name = false;
          vkbasalt = false;
          wine = false;
          winesync = false;
          cpu_text = "";
          cpu_stats = false;
          core_load = false;
          core_bars = false;
          cpu_power = false;
          cpu_temp = false;
          gpu_text = "";
          gpu_stats = false;
          gpu_power = false;
          gpu_temp = false;
          gpu_core_clock = false;
          gpu_mem_clock = false;
          gpu_fan = false;
          gpu_voltage = false;
          throttling_status = false;
          throttling_status_graph = false;
          procmem = false;
          procmem_shared = false;
          procmem_virt = false;
          ram = false;
          vram = false;
          swap = false;
          network = false;
          time = false;
          time_format = "%r";
          time_no_label = true;
          graphs = "";

          toggle_hud = "Shift_R+F12";
          toggle_logging = "Shift_L+F2";
          toggle_hud_position = "Shift_R+F11";
          toggle_preset = "Shift_R+F10";
          toggle_fps_limit = "Shift_L+F1";
          reload_cfg = "Shift_L+F4";
          reload_log = "Shift_L+F3";
          reset_fps_metrics = "Shift_R+F9";
          output_folder = "/home/${sys.username}/.config/MangoHud";

          width = 240;
          table_columns = 2;
          offset_x = 3;
          offset_y = 24;
          position = "top-left";
          legacy_layout = true;
          height = 0;
          horizontal = false;
          horizontal_stretch = false;
          hud_compact = false;
          hud_no_margin = true;
          cellpadding_y = 0;
          round_corners = 10;
          alpha = 1.000000;
          background_alpha = 1.000000;
          font_scale = 1.0;
          font_size = 24;
          font_size_text = 24;
          no_small_font = false;
          text_color = "cdd6f4";
          text_outline = true;
          text_outline_thickness = 1;
          text_outline_color = "1e1e2e";
          frametime_color = "b2bedc";
          frametime_text_color = "";
          background_color = "1d253a";
          battery_color = "ff0000";
          engine_color = "cdd6f4";
          cpu_color = "89b4fa";
          cpu_load_color = "a6e3a1, f9e2af, f38ba8";
          io_color = "f9e2af";
          media_player_color = "cdd6f4";
          gpu_color = "a6e3a1";
          gpu_load_color = "a6e3a1, f9e2af, f38ba8";
          fps_color = "a6e3a1, f9e2af, f38ba8";
          wine_color = "cba6f7";
          vram_color = "94e2d5";
        };
      };
      # OW HUD background: #1d253a
      # OW HUD text: #b2bedc
      # cat ~/.config/MangoHud/MangoHud.conf
    };

    xdg.desktopEntries = {
      rofi-rbw = {
        exec = "${pkgs.rofi-rbw-wayland}/bin/rofi-rbw";
        icon = "/home/${sys.username}/.icons/custom/bitwarden.png";
        name = "Bitwarden";
        categories = [ "Utility" "Security" ];
        type = "Application";
      };
      ollama = {
        exec = "ollama-wrapped";
        icon = "/home/${sys.username}/.icons/custom/ollama.png";
        name = "AI Chat";
        categories = [ "Utility" ];
        type = "Application";
      };
    };

    home.file = {
      "rofi-rbw.rc" = {
        target = ".config/rofi-rbw.rc";
        text = ''
          action="type"
          typing-key-delay=0
          selector-args="-W 40% -H 30%"
          selector="wofi"
          clipboarder="wl-copy"
          typer="dotool"
          keybindings="Enter:type:username:enter:tab:type:password:enter:copy:totp"
        '';
      };
      "bitwarden.png" = {
        target = ".icons/custom/bitwarden.png";
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/bitwarden/clients/refs/heads/main/apps/desktop/resources/icons/64x64.png";
          sha256 = "sha256-ZEYwxeoL8doV4y3M6kAyfz+5IoDsZ+ci8m+Qghfdp9M=";
        };
      };
      "ollama.png" = {
        target = ".icons/custom/ollama.png";
        source = pkgs.fetchurl {
          url = "https://ollama.com/public/icon-64x64.png";
          sha256 = "sha256-jzjt+wB9e3TwPSrXpXwCPapngDF5WtEYNt9ZOXB2Sgs=";
        };
      };
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
      xdg-desktop-portal-kde
    ];
  };

  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      enable = true;
      defaultSession = "plasma";
      autoLogin.enable = true;
      autoLogin.user = "${sys.username}";
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
}
