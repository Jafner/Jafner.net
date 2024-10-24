{ pkgs, ... }:{
  home.packages = with pkgs; [
    ffmpeg_7-full
    ( writeShellApplication {  
      name = "send-to-x264-mp4"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
      runtimeInputs = [
        libnotify
        ( writeShellApplication { name = "check-inputs"; } )
        ( writeShellApplication { name = "transcode-av1"; } ) # https://trac.ffmpeg.org/wiki/Encode/AV1
        ( writeShellApplication { name = "transcode-x264"; } ) # https://trac.ffmpeg.org/wiki/Encode/H.264
        ( writeShellApplication { name = "upload-zipline"; } )
        ( writeShellApplication { name = "slow-motion"; } ) # https://trac.ffmpeg.org/wiki/How%20to%20speed%20up%20/%20slow%20down%20a%20video
      ];
      text = ''
        INPUT_FILE=$(realpath "$1")

        FILE_PATH=$(dirname "$INPUT_FILE")
        FILE_NAME=$(basename "$INPUT_FILE")
        FILE_NAME="''${''\FILE_NAME%.*}"

        OUTFILE="$FILE_PATH/$FILE_NAME.mp4"

        notify-send -t 2000 "Transcode starting" "$FILE_NAME"

        nixGL ffmpeg -hide_banner -vaapi_device /dev/dri/renderD128 -i "$INPUT_FILE" -map 0 -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v 8M -c:a copy "$OUTFILE"

        notify-send -t 4000 "Transcode complete" "$FILE_NAME"
      '';
    } )
  ];
}