#!/bin/bash
#["Convert to x264"]
# Takes one or more video files (tested with AV1-encoded mkv files) and
# re-encodes them into x264 in the mp4 container for sharing on platforms like Discord

#echo "NAUTILUS_SCRIPT_SELECTED_FILE_PATHS = $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" >> temp.txt
#echo "NAUTILUS_SCRIPT_SELECTED_URIS  = $NAUTILUS_SCRIPT_SELECTED_URIS" >> temp.txt
#echo "NAUTILUS_SCRIPT_CURRENT_URI = $NAUTILUS_SCRIPT_CURRENT_URI" >> temp.txt
#echo "NAUTILUS_SCRIPT_WINDOW_GEOMETRY = $NAUTILUS_SCRIPT_WINDOW_GEOMETRY" >> temp.txt

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

# Guard statement to ensure source is mkv-contained.
if [[ "$FILE_EXT" != "mkv" ]]; then notify-send -u critical "Script error" "Only mkv-contained files are supported."; exit 1; fi

# Guard statement to ensure source is AV1-encoded.
if ! [ $(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$FILE_FULL_PATH") == "av1" ]; then notify-send -u critical "Script error" "Only AV1-encoded video files are supported."; exit 1; fi

# Actual transcoding happens here:
notify-send -t 2000 "Transcode starting" "$FILE_FULL_PATH"
ffmpeg -hide_banner -i "$FILE_FULL_PATH" -map 0 -c:v libx264 -crf 21 -preset slow -c:a copy "$FILE_PATH/$FILE_NAME.mp4"
notify-send -t 4000 "Transcode complete" "$FILE_FULL_PATH"

} > /dev/null 


### OLD VERSION
# {
# if (( $(grep -c . <<<"$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" > 1 )); then exit 1; fi
# for file in "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"; do
#     # these are declared in a specific order on purpose lol
#     FILE_PATH=$(dirname "$file")
#     FILE_NAME=$(basename "$file")
#     FILE_EXT="${FILE_NAME##*.}"
#     FILE_NAME="${FILE_NAME%.*}"
#     FILE_FULL_PATH="$FILE_PATH/$FILE_NAME.$FILE_EXT"
#     if [ $(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$FILE_FULL_PATH") == "av1" ]; then
#         echo "Processing: \"$FILE_NAME\""
# 	KEYFRAMES=( $(ffprobe -hide_banner -loglevel error -skip_frame nokey -select_streams v:0 -show_entries packet=pts,flags -of csv=print_section=0 "$FILE_FULL_PATH" | grep K | cut -d',' -f 1) )
#         keyint=$(( ${KEYFRAMES[-1]} - ${KEYFRAMES[-2]} ))
# 	echo "KEYFRAMES: $(declare -p $KEYFRAMES)"
# 	echo "keyint: $keyint"
#         # actual re-encoding happens here:
#         #ffmpeg -i "$FILE_FULL_PATH" -map 0 -c:v libx264 -crf 23 -preset slow -g $keyint -c:a copy "$FILE_PATH/$FILE_NAME.mp4"
#         ffmpeg -hide_banner -i "$FILE_FULL_PATH" -copyts -copytb 0 -map 0 -bf 0 -c:v libx264 -crf 23 -video_track_timescale 1000 -g 60 -keyint_min 60 -bsf:v setts=ts=STARTPTS+N/TB_OUT/60 -c:a copy "$FILE_PATH/$FILE_NAME.mp4"
#         notify-send -t 4000 "Transcode complete" "$FILE_FULL_PATH"
#     else
#         echo "Skipping (no av1 video stream): \"$FILE_FULL_PATH\""
#     fi
# done

# } > /dev/null 
