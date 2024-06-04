# Assign test file names/paths
SOURCE_FILE=$(realpath ~/Git/Clip/TestClips/"x264Source.mkv") && echo "SOURCE_FILE: $SOURCE_FILE"
TRANSCODED_FILE="$(realpath ~/Git/Clip/TestClips)/TRANSCODED.mp4" && echo "TRANSCODED_FILE: $TRANSCODED_FILE"

# TRANSCODE $SOURCE_FILE into 'TRANSCODED.mp4'
ffmpeg -hide_banner -i "$SOURCE_FILE" -copyts -copytb 0 -map 0 -bf 0 -c:v libx264 -crf 23 -preset slow -video_track_timescale 1000 -g 60 -keyint_min 60 -bsf:v setts=ts=STARTPTS+N/TB_OUT/60 -c:a copy "$TRANSCODED_FILE"

# GET KEYFRAMES FROM $SOURCE_FILE
KEYFRAMES=( $(ffprobe -hide_banner -loglevel error -select_streams v:0 -show_entries packet=pts,flags -of csv=print_section=0 "$SOURCE_FILE" | grep K | cut -d',' -f 1) ) && echo "$KEYFRAMES"
ffprobe -hide_banner -loglevel error -select_streams v:0 -show_entries packet=pts,flags -of csv=print_section=0 "$SOURCE_FILE"

# GET KEYFRAMES FROM $TRANSCODED_FILE
KEYFRAMES=( $(ffprobe -hide_banner -loglevel error -select_streams v:0 -show_entries packet=pts,flags -of csv=print_section=0 "$TRANSCODED_FILE" | grep K | cut -d',' -f 1) ) && echo "$KEYFRAMES"
ffprobe -hide_banner -loglevel error -select_streams v:0 -show_entries packet=pts,flags -of csv=print_section=0 "$TRANSCODED_FILE"

# Compare keyframes between $SOURCE_FILE and $TRANSCODED_FILE
sdiff <(ffprobe -hide_banner -loglevel error -select_streams v:0 -show_entries packet=pts,flags -of csv=print_section=0 "$SOURCE_FILE") <(ffprobe -hide_banner -loglevel error -select_streams v:0 -show_entries packet=pts,flags -of csv=print_section=0 "$TRANSCODED_FILE")

https://code.videolan.org/videolan/x264/-/blob/master/common/base.c#L489