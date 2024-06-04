import subprocess
from pathlib import Path
import numpy as np
import ffmpeg

# Get a list of keyframes by pts (milliseconds from start) from a video file.
def get_keyframes_list(video_path):
    ffprobe_command = [
        "ffprobe", 
        "-hide_banner",
        "-loglevel", "error",
        "-skip_frame", "nokey",
        "-select_streams", "v:0",
        "-show_entries", "packet=pts,flags",
        "-of", "csv=print_section=0",
        video_path
    ]

    ffprobe_output = subprocess.run(ffprobe_command, capture_output=True, text=True)
    keyframes = list(map(int, np.array([line.split(",") for line in list(filter(lambda frame_packet: "K" in frame_packet, ffprobe_output.stdout.splitlines()))])[:,0]))
    if len(keyframes) <= 1:
        # Pop up a warning if there are no keyframes.
        return(None)
    return(keyframes)

def get_keyframe_interval(keyframes_list: list): # Takes a list of ints representing keyframe pts (milliseconds from start) and returns either the keyframe interval in milliseconds, or None if the keyframe intervals are not all the same.
    intervals = list(np.diff(keyframes_list)) # List of keyframe intervals in milliseconds.
    if np.all(intervals == intervals[0]):
        return(intervals[0])
    else:
        return(0)

def get_keyframe_intervals(keyframes_list):
    # Return a list of keyframe intervals in milliseconds.
    return(list(np.diff(keyframes_list)))

def keyframe_intervals_are_clean(keyframe_intervals):
    # Return whether the keyframe intervals are all the same.
    return(np.all(keyframe_intervals == keyframe_intervals[0]))

# Get the duration of a video file in milliseconds (useful for ffmpeg pts).
def get_video_duration(video_path):
    return int(float(ffmpeg.probe(video_path)["format"]["duration"])*1000)