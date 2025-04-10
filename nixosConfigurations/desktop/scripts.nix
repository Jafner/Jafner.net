{ pkgs, username, ... }: {
  sops.secrets.zipline = {
    sopsFile = ../../hosts/desktop/secrets/zipline.token;
    key = "";
    mode = "0440";
    format = "binary";
    owner = username;
  };
  sops.secrets."cloudflare/id" = {
    sopsFile = ../../hosts/desktop/secrets/cloudflare_id.token;
    key = "";
    mode = "0440";
    format = "binary";
    owner = username;
  };
  sops.secrets."cloudflare/token" = {
    sopsFile = ../../hosts/desktop/secrets/cloudflare_stream.token;
    key = "";
    mode = "0440";
    format = "binary";
    owner = username;
  };
  home-manager.users."${username}" = {
    home.packages = [
      ( pkgs.writeShellApplication {
        name = "convert-to";
        runtimeInputs = with pkgs; [
          libnotify
          ffmpeg-full
          ffpb
        ];
        text = ''
          ARGS=()
          BITRATE="8M"
          MODE="copy"
          DRY_RUN=false
          PROFILE=""

          while [[ $# -gt 0 ]]; do
            # shellcheck disable=SC2221,SC2222
            case $1 in
              -b|--bitrate)
                BITRATE="$2"
                shift
                shift
                ;;
              -r|--replace)
                MODE=replace
                shift
                ;;
              --profile)
                PROFILE="$2"
                shift
                shift
                ;;
              -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
              -*|--*)
                echo "Unknown option $1"
                exit 1
                ;;
              *)
                ARGS+=("$1")
                shift
                ;;
            esac
          done
          set -- "''$''\{ARGS[@]}"

          INPUT_FILE_PATH="$(realpath "$1")"
          INPUT_FILE_NAME="''$''\{INPUT_FILE_PATH%.*}"
          if [[ $# -gt 1 ]]; then echo "Error: Expected 1 positional argument, got $#"; exit 1; fi
          if ! [[ -f "$1" ]]; then echo "Error: File not found $1"; exit 1; fi

          if [[ "$MODE" == "replace" ]]; then
            FFMPEG_CMD_DESTINATION="$INPUT_FILE_NAME.tmp.mp4 && mv \"$INPUT_FILE_NAME.tmp.mp4\" \"$INPUT_FILE_NAME.mp4\""
          else
            if [[ -f "$INPUT_FILE_NAME.mp4" ]]; then
              FFMPEG_CMD_DESTINATION="$INPUT_FILE_NAME copy.mp4"
            else
              FFMPEG_CMD_DESTINATION="$INPUT_FILE_NAME.mp4"
            fi
          fi

          if [[ -z "$PROFILE" ]]; then
            FFMPEG_CMD="-hide_banner -nostdin -vaapi_device /dev/dri/renderD128 -i \"$INPUT_FILE_PATH\" -y -map 0 -vf 'format=nv12,hwupload' -c:v av1_vaapi -b:v \"$BITRATE\" -c:a copy \"$FFMPEG_CMD_DESTINATION\""
          elif [[ "$PROFILE" == "mp4" ]]; then
            FFMPEG_CMD="-hide_banner -nostdin -i \"$INPUT_FILE_PATH\" -y -map 0 -c:v copy -c:a copy \"$FFMPEG_CMD_DESTINATION\""
          elif [[ "$PROFILE" == "slowmo" ]]; then
            FFMPEG_CMD="-hide_banner -nostdin -itsscale 2 -i \"$INPUT_FILE_PATH\" -y -codec copy -an \"$FFMPEG_CMD_DESTINATION\""
          elif [[ "$PROFILE" == "1080p60" ]]; then
            FFMPEG_CMD="-hide_banner -nostdin -vaapi_device /dev/dri/renderD128 -i \"$INPUT_FILE_PATH\" -y -map 0 -vf 'format=nv12,scale=-1:1080,hwupload' -c:v av1_vaapi -b:v \"$BITRATE\" -c:a copy -r 60 \"$FFMPEG_CMD_DESTINATION\""
          elif [[ "$PROFILE" == "1080p30" ]]; then
            FFMPEG_CMD="-hide_banner -nostdin -vaapi_device /dev/dri/renderD128 -i \"$INPUT_FILE_PATH\" -y -map 0 -vf 'format=nv12,scale=-1:1080,hwupload' -c:v av1_vaapi -b:v \"$BITRATE\" -c:a copy -r 30 \"$FFMPEG_CMD_DESTINATION\""
          elif [[ "$PROFILE" == "720p60" ]]; then
            FFMPEG_CMD="-hide_banner -nostdin -vaapi_device /dev/dri/renderD128 -i \"$INPUT_FILE_PATH\" -y -map 0 -vf 'format=nv12,scale=-1:720,hwupload' -c:v av1_vaapi -b:v \"$BITRATE\" -c:a copy -r 60 \"$FFMPEG_CMD_DESTINATION\""
          elif [[ "$PROFILE" == "720p30" ]]; then
            FFMPEG_CMD="-hide_banner -nostdin -vaapi_device /dev/dri/renderD128 -i \"$INPUT_FILE_PATH\" -y -map 0 -vf 'format=nv12,scale=-1:720,hwupload' -c:v av1_vaapi -b:v \"$BITRATE\" -c:a copy -r 30 \"$FFMPEG_CMD_DESTINATION\""
          else
            echo "Error: Unknown profile $PROFILE"
            exit 1
          fi

          if [[ $DRY_RUN == true ]]; then
            echo "${pkgs.ffmpeg}/bin/ffmpeg $FFMPEG_CMD"
          else
            eval "${pkgs.ffmpeg}/bin/ffmpeg $FFMPEG_CMD"
          fi
        '';
      } )
      ( pkgs.writeShellApplication {
        name = "send-to";
        runtimeInputs = with pkgs; [
          libnotify
          curl
          jq
          wl-clipboard
          wl-clip-persist
        ];
        text = ''
          function cloudflare {
            CLOUDFLARE_URL="https://api.cloudflare.com/client/v4/accounts/$1/stream"
            CLOUDFLARE_STREAM_TOKEN="$2"
            INPUT_FILE_PATH="$3"

            notify-send -t 2000 "Uploading to Cloudflare Stream"
            # shellcheck disable=SC2086,SC2005
            echo "$(curl -X POST \
              --header "Authorization: Bearer $CLOUDFLARE_STREAM_TOKEN" \
              --form "file=@$INPUT_FILE_PATH" \
              $CLOUDFLARE_URL
            )" | jq -r '.result.preview'
            notify-send -t 4000 "Upload complete."
          }

          function zipline {
            ZIPLINE_HOST="$1/api/upload"
            ZIPLINE_TOKEN="$2"
            INPUT_FILE_PATH="$3"
            notify-send -t 2000 "Uploading to Zipline"
            # shellcheck disable=SC2005
            echo "$(curl \
              --header "authorization: $ZIPLINE_TOKEN" \
              "$ZIPLINE_HOST" -F "file=@$INPUT_FILE_PATH" \
              --header "Content-Type: multipart/form-data" \
              --header "Format: name" \
              --header "Embed: true" \
              --header "Original-Name: true"
            )" | jq -r .'files[0]'
            notify-send -t 4000 "Upload complete."
          }

          # Expects: [zipline|cloudflare] {dest} {auth} {file}
          #   e.g. send-to zipline "https://zipline.jafner.net" "$(cat /run/secrets/zipline)" "somefile.mp4"
          #   or send-to cloudflare "https://api.cloudflare.com/client/v4/accounts/$(cat /run/secrets/cloudflare/id)/stream" "$(cat /run/secrets/cloudflare/token)" "somefile.mp4"

          MODE="$1"; shift
          HOST="$1"; shift
          AUTH="$1"; shift
          FILE="$1"

          if ! [[ -f "$1" ]]; then echo "Error: File not found $1"; exit 1; fi

          if [[ "$MODE" == "cloudflare" ]]; then cloudflare "$HOST" "$AUTH" "$FILE"
          elif [[ "$MODE" == "zipline" ]]; then zipline "$HOST" "$AUTH" "$FILE"
          else echo "Error: Unknown mode $MODE"; exit 1; fi

        '';
      } )
      ( pkgs.writeShellApplication {
        name = "fix-hm-collision";
        text = ''
          rm "$(systemctl status home-manager-joey.service --no-pager --lines=200 |\
            grep "Existing file" |\
            cut -d':' -f4 |\
            cut -d' ' -f4 |\
            xargs \
          )"
        '';
      } )
    ];
    home.file = let launcher = "${pkgs.kitty}/bin/kitty --override initial_window_width=1280 --override initial_window_height=720 --override remember_window_size=no"; in { # Note: Will need to be integrated with any file manager that isn't dolphin
      "convert-video-to" = {
        target = ".local/share/kio/servicemenus/convert-video-to.desktop";
        text = ''
          [Desktop Entry]
          Type=Service
          MimeType=video/*;
          Actions=convertAndReplace;convertAndCopy;convertToMp4;convertToSlowmo;convertToSlowmoDry;convert1080p60;convert1080p30;convert720p60;convert720p30
          X-KDE-Submenu=Convert to...

          [Desktop Action convertAndReplace]
          Name=Convert and replace
          Icon=video-mp4
          Exec=${launcher} convert-to --replace "%f"

          [Desktop Action convertAndCopy]
          Name=Convert and copy
          Icon=video-mp4
          Exec=${launcher} convert-to "%f"

          [Desktop Action convertToMp4]
          Name=Convert to MP4
          Icon=video-mp4
          Exec=${launcher} convert-to --profile mp4 "%f"

          [Desktop Action convertToSlowmo]
          Name=Convert to slow-motion (0.5x)
          Icon=video-mp4
          Exec=${launcher} convert-to --profile slowmo "%f"

          [Desktop Action convertToSlowmoDry]
          Name=Convert to slow-motion (0.5x) (dry-run)
          Icon=video-mp4
          Exec=${launcher} convert-to --dry-run --profile slowmo "%f"

          [Desktop Action convert1080p60]
          Name=Convert to 1080p60
          Icon=video-mp4
          Exec=${launcher} convert-to --profile 1080p60 "%f"

          [Desktop Action convert1080p30]
          Name=Convert to 1080p30
          Icon=video-mp4
          Exec=${launcher} convert-to --profile 1080p30 "%f"

          [Desktop Action convert720p60]
          Name=Convert to 720p60
          Icon=video-mp4
          Exec=${launcher} convert-to --profile 720p60 "%f"

          [Desktop Action convert720p30]
          Name=Convert to 720p30
          Icon=video-mp4
          Exec=${launcher} convert-to --profile 720p30 "%f"
        '';
      };
      "send-video-to" = {
        target = ".local/share/kio/servicemenus/send-video-to.desktop";
        text = ''
          [Desktop Entry]
          Type=Service
          MimeType=video/*;
          Actions=sendToZipline;sendToCloudflare;
          X-KDE-Submenu=Send to...

          [Desktop Action sendToZipline]
          Name=Send to Zipline
          Icon=video-mp4
          Exec=${launcher} send-to zipline "https://zipline.jafner.net/api/upload" "$(cat /run/secrets/zipline)" "%f" | wl-copy

          [Desktop Action sendToCloudflare]
          Name=Send to Cloudflare
          Icon=video-mp4
          Exec=${launcher} send-to cloudflare "$(cat /run/secrets/cloudflare/id)" "$(cat /run/secrets/cloudflare/token)" "%f" | wl-copy
        '';
      };
    };
  };
}

# For more rapid iteration:
# cp $(realpath $(which send-to)) ./send-to; chmod +rwx ./send-to; alias send-to="$(realpath ./send-to)"
# cp $(realpath $(which convert-to)) ./convert-to; chmod +rwx ./convert-to; alias convert-to="$(realpath ./convert-to)"
