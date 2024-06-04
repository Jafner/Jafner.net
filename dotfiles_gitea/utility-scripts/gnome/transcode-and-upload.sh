#!/bin/bash
#["Convert and Share to Zipline"]

# Takes one AV1-encoded, mkv-contained video file and
# transcodes it into x264 in the mp4 container,
# then uploads the new file to zipline and copies the link to the clipboard.
# The new file is ephemeral to the user, as it is deleted after uploading. 


{
echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" > ~/.nautilus_script_selected_file_paths
# Guard statement to exit if multiple files are selected.
if (( $(grep -c . <<<"$(cat ~/.nautilus_script_selected_file_paths)") > 1 )); then notify-send -u critical "Script error" "Selecting more than 1 file is not supported."; exit 1; fi
file="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# these are declared in a specific order on purpose lol
FILE_PATH=$(dirname "$file")
FILE_NAME=$(basename "$file")
FILE_EXT="${FILE_NAME##*.}"
FILE_NAME="${FILE_NAME%.*}"
FILE_FULL_PATH="$FILE_PATH/$FILE_NAME.$FILE_EXT"
FILE_TMP_DIR="/tmp/$FILE_NAME.mp4"

# Guard statement to ensure source is mkv-contained.
if [[ "$FILE_EXT" != "mkv" ]]; then notify-send -u critical "Script error" "Only mkv-contained files are supported."; exit 1; fi

# Guard statement to ensure source is AV1-encoded.
if ! [ $(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$FILE_FULL_PATH") == "av1" ]; then notify-send -u critical "Script error" "Only AV1-encoded video files are supported."; exit 1; fi

# Actual transcoding happens here:
notify-send -t 4000 "Beginning transcode" "$FILE_NAME"
ffmpeg -hide_banner -i "$FILE_FULL_PATH" -map 0 -c:v libx264 -crf 21 -preset slow -c:a copy "$FILE_TMP_DIR"
notify-send -t 4000 "Transcode complete" "$FILE_NAME"

} > /dev/null 

{
ZIPLINE_HOST_ROOT=https://zipline.jafner.net
file="$FILE_TMP_DIR"
TOKEN=$(cat ~/.zipline-auth)
LINK=$(curl \
    --header "authorization: $TOKEN" \
    $ZIPLINE_HOST_ROOT/api/upload -F "file=@$FILE_TMP_DIR" \
    --header "Content-Type: multipart/form-data" \
    --header "Format: name" \
    --header "Embed: true" \
    --header "Original-Name: true") 
LINK=$(echo "$LINK" | jq -r .'files[0]')
echo "[$FILE_NAME]($LINK)" | wl-copy
notify-send -t 4000 "Zipline - Upload complete." "Link copied to clipboard: $LINK"
} > /dev/null

rm "$FILE_TMP_DIR"