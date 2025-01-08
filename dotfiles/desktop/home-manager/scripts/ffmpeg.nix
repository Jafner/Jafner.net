{ pkgs, ... }: { 
  home.packages = with pkgs; [
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
        ffmpeg -hide_banner -vaapi_device /dev/dri/renderD128 -i "$INPUT_FILE" -map 0 -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v 8M -c:a copy "$OUTFILE"
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

        INPUT_FILE=$(realpath "$INPUT_FILE")
        FILE_NAME=$(basename "$INPUT_FILE")
        FILE_NAME="''$''\{FILE_NAME%.*}"

        ZIPLINE_HOST_ROOT=https://zipline.jafner.net
        TOKEN=$(cat ~/.zipline-auth)
        LINK=$(curl \
            --header "authorization: $TOKEN" \
            $ZIPLINE_HOST_ROOT/api/upload -F "file=@$INPUT_FILE" \
            --header "Content-Type: multipart/form-data" \
            --header "Format: name" \
            --header "Embed: true" \
            --header "Original-Name: true") 
        LINK=$(echo "$LINK" | jq -r .'files[0]')
        echo "[$FILE_NAME]($LINK)" | wl-copy
        notify-send -t 4000 "Zipline - Upload complete." "Link copied to clipboard: $LINK"
      '';
    } )
  ];
  home.file."send-to-ffmpeg.desktop" = {
    target = ".local/share/kio/servicemenus/send-to-ffmpeg.desktop";
    text = ''
      [Desktop Entry]
      Type=Service
      ServiceTypes=KonqPopupMenu/Plugin
      MimeType=video/*;
      Icon=video-mp4
      X-KDE-Submenu=Run script...
      Actions=convertForDiscord;sendToZipline

      [Desktop Action convertForDiscord]
      Name=Convert for Discord
      Icon=video-mp4
      TryExec=ffmpeg
      Exec=file=%f; convert-for-discord "%f"

      [Desktop Action sendToZipline]
      Name=Send to Zipline
      Icon=video-mp4
      TryExec=ffmpeg
      Exec=file=%f; send-to-zipline "%f"
    '';
  };
}
