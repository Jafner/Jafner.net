# Version using ffPyPlayer
from pathlib import Path
import tkinter as tk
import time
from ffpyplayer.player import MediaPlayer

def ffplaySegment(file: Path, start: int, end: int):
    print(f"Playing {file} from {start}ms to {end}ms")
    file = str(file) # Must be string
    seek_to = float(start)/1000
    play_for = float(end - start)/1000
    x = int(1280)
    y = int(720)
    volume = float(0.2) # Float 0.0 to 1.0
    # Must be dict
    ff_opts = {
        "paused": False, # Bool
        "t": play_for, # Float seconds
        "ss": seek_to, # Float seconds
        "x": x,
        "y": y,
        "volume": volume
    }
    val = ''
    player = MediaPlayer(file, ff_opts=ff_opts)
    while val != 'eof':
        frame, val = player.get_frame()
        print(f"frame: (type: {type(frame)})", end=', ')
        if val != 'eof' and frame is not None:
            img, t = frame
            print(f"img: (type: {type(img)})", end=', ')
            print(f"t: (type: {type(t)})")
            # Use the create_image  method of the canvas widget to draw the image to the canvas.
            
            
