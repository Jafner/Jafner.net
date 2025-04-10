# ffaart: Fidelity-First Automagical AV1 Reencoding to Target
#   An intelligent video transcoding utility which prioritizes perceptual quality
#   while leveraging AV1 to reduce file sizes with minimal manual input.
#
# Usage: ffaart [--bitrate B] [--resolution X Y] [--framerate R] file

function main {
  export "INPUT_FILE_PATH=$(realpath "$1")"
  export "INPUT_FILE_EXT=''$''\{INPUT_FILE_PATH##*.}"
  export "INPUT_FILE_NAME=''$''\{INPUT_FILE_PATH%.*}"
  # TODO: Figure out how to turn "$@" into a fully defined set of targets.
  # TARGET_RESOLUTION
  # TARGET_FRAMERATE
  # TARGET_BITRATE
  #magic "$@"

  assert_mp4 "$INPUT_FILE_PATH"

  # Literally just to make something that runs.
  # Please replace this for the love of god.
  TARGET_RESOLUTION_X="1920"
  TARGET_RESOLUTION_Y="1080"
  TARGET_FRAMERATE="60"
  TARGET_BITRATE="4M"

  ffmpeg \
    -hide_banner \
    -nostdin \
    -loglevel error \
    -vaapi_device /dev/dri/renderD128 \
    -i "$INPUT_FILE_NAME.mp4" \
    -y \
    -vf "scale=w=$TARGET_RESOLUTION_X:h=$TARGET_RESOLUTION_Y:format=nv12,hwupload" \
    -c:v av1_vaapi \
    -r "$TARGET_FRAMERATE" \
    -b:v "$TARGET_BITRATE" \
    "output.mp4" # REPLACE WITH A REAL OUTPUT FILE
}

function assert_mp4 {
  if [[ "$INPUT_FILE_EXT" != "mp4" ]]; then
    ffmpeg -hide_banner -nostdin -loglevel error -i "$INPUT_FILE_PATH" -copy "$INPUT_FILE_NAME.mp4"
  fi
}

main "$@"
