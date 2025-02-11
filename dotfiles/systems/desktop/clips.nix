{ pkgs, sys, ... }: {
  sops.secrets.clips = { 
    sopsFile = ./clips.secrets;
    key = "";
    mode = "0440";
    format = "binary";
    owner = sys.username;
  };
  home-manager.users."${sys.username}" = {
    home.packages = with pkgs; [
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

          export $(cat /run/secrets/clips)

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

          export $(cat /run/secrets/clips)

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
          
          export $(cat /run/secrets/clips)

          notify-send -t 2000 "Zipline and Cloudflare - Beginning upload."
          RESPONSE=$(curl \
              --header "authorization: $TOKEN" \
              $ZIPLINE_HOST_ROOT/api/upload -F "file=@$INPUT_FILE" \
              --header "Content-Type: multipart/form-data" \
              --header "Format: name" \
              --header "Embed: true" \
              --header "Original-Name: true")
          LINK=$(echo "$RESPONSE" | jq -r .'files[0]' | sed 's/\/u\//\/r\//')

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
    ];
  };
}