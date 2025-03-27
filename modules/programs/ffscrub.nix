{ pkgs, config, ... }: let cfg = config.modules.programs.ffscrub; in {
  options = with pkgs.lib; {
    modules.programs.ffscrub = {
      enable = mkEnableOption "ffscrub";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    home-manager.users."${cfg.username}".home.packages = with pkgs; [
      ( writeShellApplication {
        name = "ffscrub";
        runtimeInputs = [
            ffmpeg-full
            file
        ];
        text = ''
            function handle_file {
            INPUT_FILE="$1"
            FILE_EXT="''$''\{INPUT_FILE##*.}"
            FILE_NAME="''$''\{INPUT_FILE%.*}"

            echo -n "$INPUT_FILE: "

            # ignore non-video files
            if ! [[ $(file --brief --mime-type "$INPUT_FILE") =~ "video/"* ]]; then echo "skipped: non-video"; return; fi

            CONTAINER="''$''\{FILE_EXT}" # this is lazy. do something better
            VCODEC="$(get_vcodec "$INPUT_FILE")"
            ACODEC="$(get_acodec "$INPUT_FILE")"

            if [[ "''$''\{CONTAINER}/''$''\{VCODEC}/''$''\{ACODEC}" == "mp4/h264/aac" ]]; then echo "skipped: already mp4/h264/aac"; return; fi

            # if we get to this point, we know we've gotta do *something* with this file.

            FFMPEG_CMD="ffmpeg -hide_banner -nostdin -loglevel error -vaapi_device /dev/dri/renderD128 -i \"$INPUT_FILE\" -y "

            # build the ffmpeg command components
            if [[ "''$''\{VCODEC}" == "h264" ]]
                then FFMPEG_CMD+="-c:v copy "
                else FFMPEG_CMD+="-vf \"format=nv12,hwupload\" -c:v h264_vaapi "
            fi
            if [[ "''$''\{ACODEC}" == "aac" ]]
                then FFMPEG_CMD+="-c:a copy "
                else FFMPEG_CMD+="-c:a aac "
            fi
            if [[ "''$''\{CONTAINER}" == "mp4" ]]
                then FFMPEG_CMD+="\"$FILE_NAME.tmp.mp4\" && mv \"$FILE_NAME.tmp.mp4\" \"$FILE_NAME.mp4\""
                else FFMPEG_CMD+="\"$FILE_NAME.mp4\" && rm \"$INPUT_FILE\""
            fi

            # run the ffmpeg command
            echo "Running: $FFMPEG_CMD"
            echo -n "status: "
            bash -c "$FFMPEG_CMD" && echo "completed: success"
            }

            function get_vcodec {
            FILE_PATH="$1"
            V=$(ffprobe \
                -v error \
                -select_streams v:0 \
                -show_entries stream=codec_name \
                -of default=noprint_wrappers=1:nokey=1 \
                "$FILE_PATH")
            echo "''$''\{V}"
            }

            function get_acodec {
            FILE_PATH="$1"
            A=$(ffprobe \
                -v error \
                -select_streams a:0 \
                -show_entries stream=codec_name \
                -of default=noprint_wrappers=1:nokey=1 \
                "$FILE_PATH")
            echo "''$''\{A}"
            }

            function get_cva {
            INPUT_FILE="$1"

            if ! [[ $(file --brief --mime-type "$INPUT_FILE") =~ "video/"* ]]; then echo "''$''\{INPUT_FILE##*.}/na/na"; return; fi

            CONTAINER="''$''\{INPUT_FILE##*.}" # this is lazy. do something better
            VCODEC="$(get_vcodec "$INPUT_FILE")"
            ACODEC="$(get_acodec "$INPUT_FILE")"
            echo "''$''\{CONTAINER}/''$''\{VCODEC}/''$''\{ACODEC}"
            }

            function get_files {
            LIBRARY_PATH="$(realpath "$1")"
            find "$LIBRARY_PATH" -type f \
                -regextype posix-extended \
                -iregex "^.*\.(asf|avi|divx|flv|m4v|mkv|mp4|mov|vob|webm|wmv)" \
                -print
            }

            "$@"
        '';
      } )
    ];
  };
}
