import tkinter as tk # https://docs.python.org/3/library/tkinter.html
from tkinter import filedialog, ttk
import av
import subprocess
from pathlib import Path
import time
import datetime
from PIL import Image, ImageTk, ImageOps
from RangeSlider.RangeSlider import RangeSliderH
from ffpyplayer.player import MediaPlayer
from probe import get_keyframes_list, get_keyframe_interval, get_video_duration

class VideoClipExtractor:
    def __init__(self, master):
        # Initialize variables
        self.video_duration = int() # milliseconds
        self.video_path = Path() # Path object
        self.video_keyframes = list() # list of ints (keyframe pts in milliseconds)
        self.clip_start = tk.IntVar(value = 0) # milliseconds
        self.clip_end = tk.IntVar(value = 1) # milliseconds
        
        self.preview_image_timestamp = tk.IntVar(value = 0) # milliseconds

        self.debug_checkvar = tk.IntVar() # Checkbox variable

        self.background_color = "#BBBBBB" 
        self.text_color = "#000000"
        self.preview_background_color = "#2222FF"

        # Set up master UI
        self.master = master
        self.master.title("Video Clip Extractor")
        self.master.configure(background=self.background_color)
        self.master.resizable(False, False)
        self.master.geometry("")
        self.window_max_width = self.master.winfo_screenwidth()*0.75
        self.window_max_height = self.master.winfo_screenheight()*0.75
        self.preview_width = 1280
        self.preview_height = 720
        self.preview_image = Image.new("RGB", (self.preview_width, self.preview_height), color=self.background_color)
        self.preview_image_tk = ImageTk.PhotoImage(self.preview_image)
        
        self.timeline_width = self.preview_width
        self.timeline_height = 64

        self.interface_width = self.preview_width
        self.interface_height = 200

        # Initialize frames, buttons and labels
        self.preview_frame = tk.Frame(self.master, width=self.preview_width, height=self.preview_height, bg=self.preview_background_color, borderwidth=0, bd=0)
        self.timeline_frame = tk.Frame(self.master, width=self.timeline_width, height=self.timeline_height, bg=self.background_color)
        self.interface_pane = tk.Frame(self.master, width=self.interface_width, height=self.interface_height, bg=self.background_color)
        self.buttons_pane = tk.Frame(self.interface_pane, bg=self.background_color)
        self.info_pane = tk.Frame(self.interface_pane, bg=self.background_color)

        self.preview_canvas = tk.Canvas(self.preview_frame, width=self.preview_width, height=self.preview_height, bg=self.preview_background_color, borderwidth=0, bd=0)
        self.browse_button = tk.Button(self.buttons_pane, text="Browse...", command=self.browse_video_file, background=self.background_color, foreground=self.text_color)
        self.extract_button = tk.Button(self.buttons_pane, text="Extract Clip", command=self.extract_clip, background=self.background_color, foreground=self.text_color)
        self.debug_checkbutton = tk.Checkbutton(self.buttons_pane, text="Print ffmpeg to console", variable=self.debug_checkvar, background=self.background_color, foreground=self.text_color)
        self.preview_button = tk.Button(self.buttons_pane, text="Preview Clip", command=self.ffplaySegment, background=self.background_color, foreground=self.text_color)
        self.video_path_label = tk.Label(self.info_pane, text=f"Source video: {self.video_path}", background=self.background_color, foreground=self.text_color)
        self.clip_start_label = tk.Label(self.timeline_frame, text=f"{self.timeStr(self.clip_start.get())}", background=self.background_color, foreground=self.text_color)
        self.clip_end_label = tk.Label(self.timeline_frame, text=f"{self.timeStr(self.clip_end.get())}", background=self.background_color, foreground=self.text_color)
        self.video_duration_label = tk.Label(self.info_pane, text=f"Video duration: {self.timeStr(self.video_duration)}", background=self.background_color, foreground=self.text_color)
        self.timeline_canvas = tk.Canvas(self.timeline_frame, width=self.preview_width, height=self.timeline_height, background=self.background_color)
        self.timeline = RangeSliderH(
                self.timeline_canvas, 
                [self.clip_start, self.clip_end],  
                max_val=max(self.video_duration,1), 
                show_value=False, 
                bgColor=self.background_color,
                Width=self.timeline_width,
                Height=self.timeline_height
            )
        self.preview_label = tk.Label(self.preview_frame, image=self.preview_image_tk)

        print(f"Widget widths (after pack):\n\
            self.clip_start_label.winfo_width(): {self.clip_start_label.winfo_width()}\n\
            self.clip_end_label.winfo_width(): {self.clip_end_label.winfo_width()}\n\
            self.timeline.winfo_width(): {self.timeline.winfo_width()}\n\
        ")

        # Arrange frames inside master window
        self.preview_frame.pack(side='top', fill='both', expand=True, padx=0, pady=0)
        self.timeline_frame.pack(fill='x', expand=True, padx=20, pady=20)
        self.interface_pane.pack(side='bottom', fill='both', expand=True, padx=10, pady=10)
        self.buttons_pane.pack(side='left')
        self.info_pane.pack(side='right')

        # Draw elements inside frames
        self.browse_button.pack(side='top')
        self.extract_button.pack(side='top')
        self.preview_button.pack(side='top')
        self.debug_checkbutton.pack(side='top')
        self.video_path_label.pack(side='top')
        self.clip_start_label.pack(side='left')
        self.clip_end_label.pack(side='right')
        self.video_duration_label.pack(side='top')
        self.preview_label.pack(fill='both', expand=True)

        # Draw timeline canvas and timeline slider
        self.timeline_canvas.pack(fill="both", expand=True)
        self.timeline.pack(fill="both", expand=True)

        print(f"Widget widths (after pack):\n\
            self.clip_start_label.winfo_width(): {self.clip_start_label.winfo_width()}\n\
            self.clip_end_label.winfo_width(): {self.clip_end_label.winfo_width()}\n\
            self.timeline.winfo_width(): {self.timeline.winfo_width()}\n\
        ")

    def getThumbnail(self):
        with av.open(str(self.video_path)) as container:
            time_ms = self.clip_start.get() # This works as long as container has a timebase of 1/1000
            container.seek(time_ms, stream=container.streams.video[0])
            time.sleep(0.1)
            frame = next(container.decode(video=0)) # Get the frame object for the seeked timestamp
        if self.preview_image_timestamp != time_ms:
            self.preview_image_tk = ImageTk.PhotoImage(frame.to_image(width=self.preview_width, height=self.preview_height)) # Convert the frame object to an image
            self.preview_label.config(image=self.preview_image_tk)
            self.preview_image_timestamp = time_ms
            
    def ffplaySegment(self):
        ffplay_command = [
            "ffplay",
            "-hide_banner",
            "-autoexit",
            "-volume", "10",
            "-window_title", f"{self.timeStr(self.clip_start.get())} to {self.timeStr(self.clip_end.get())}",
            "-x", "1280",
            "-y", "720",
            "-ss", f"{self.clip_start.get()}ms",
            "-i", str(self.video_path),
            "-t", f"{self.clip_end.get() - self.clip_start.get()}ms"
        ]
        print("Playing video. Press \"q\" or \"Esc\" to exit.")
        print("")
        subprocess.run(ffplay_command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


    def redrawTimeline(self):
        self.timeline.forget()
        step_size = get_keyframe_interval(self.video_keyframes)
        step_marker = False
        if len(self.video_keyframes) < self.timeline_width/4 and step_size > 0:
            step_marker = True
        self.timeline = RangeSliderH(
                self.timeline_canvas, 
                [self.clip_start, self.clip_end], 
                max_val=max(self.video_duration,1), 
                step_marker=step_marker,
                step_size=step_size,
                show_value=False,
                bgColor=self.background_color,
                Width=self.timeline_width,
                Height=self.timeline_height
            )
        self.timeline.pack()
        #self.preview_canvas.create_text(self.preview_canvas.winfo_width() // 2, self.preview_canvas.winfo_height() // 2, text=f"Loading video...", fill="black", font=("Helvetica", 48))
        

    def timeStr(self, milliseconds: int): # Takes milliseconds int or float and returns a string in the preferred format
        h = int(milliseconds/3600000) # Get the hours component
        m = int((milliseconds%3600000)/60000) # Get the minutes component
        s = int((milliseconds%60000)/1000) # Get the seconds component
        ms = int(milliseconds%1000) # Get the milliseconds component
        if milliseconds < 60000:
            return f"{s}.{ms:03}"
        elif milliseconds < 3600000:
            return f"{m}:{s:02}.{ms:03}"
        else:
            return f"{h}:{m:02}:{s:02}.{ms:03}"

    def clip_selector(self):
        def updateClipRange(var, index, mode):
            clip_end = self.clip_end.get()
            nearest_keyframe_start = self.nearest_keyframe(self.clip_start.get(), self.video_keyframes)
            # Add a specific check to make sure that the clip end is not changing to be equal to or less than the clip start
            if clip_end <= nearest_keyframe_start:
                clip_end = nearest_keyframe_start + self.timeline.__dict__['step_size']
            self.clip_start_label.config(text=f"{self.timeStr(nearest_keyframe_start)}")
            self.clip_end_label.config(text=f"{self.timeStr(clip_end)}")
            self.timeline.forceValues([nearest_keyframe_start, clip_end])
            self.getThumbnail()
        if str(self.video_path) == "()":
            return False
        self.clip_start.trace_add("write", callback=updateClipRange) # This actually triggers on both start and end

    def nearest_keyframe(self, test_pts: int, valid_pts: list): 
        return(min(valid_pts, key=lambda x:abs(x-float(test_pts))))

    def browse_video_file(self):
        video_path = filedialog.askopenfilename(
            initialdir="~/Git/Clip/TestClips/", 
            title="Select file",
            filetypes=(("mp4/mkv files", '*.mp4 *.mkv'), ("all files", "*.*"))
        )
        print(f"video path: \"{video_path}\" (type: {type(video_path)})")
        if not Path(str(video_path)).is_file():
            return
        video_keyframes = get_keyframes_list(video_path)
        while video_keyframes == None:
            print(f"No keyframes found in {video_path}. Choose a different video file.")
            video_path = filedialog.askopenfilename(
            initialdir="~/Git/Clip/TestClips/", 
            title="Select file",
            filetypes=(("mp4/mkv files", '*.mp4 *.mkv'), ("all files", "*.*"))
        )
        # Once we have a video file, we need to set the Source video, Clip start, Clip end, and Video duration values and redraw the GUI.
        self.video_path = Path(video_path)
        self.video_duration = get_video_duration(video_path)
        self.video_keyframes = video_keyframes
        self.clip_start.set(min(self.video_keyframes))
        self.clip_end.set(max(self.video_keyframes))
        self.clip_start_label.config(text=f"{self.timeStr(self.nearest_keyframe(self.clip_start.get(), self.video_keyframes))}")
        self.clip_end_label.config(text=f"{self.timeStr(self.clip_end.get())}")

        self.getThumbnail()

        self.video_path_label.config(text=f"Source video: {self.video_path}")
        self.video_duration_label.config(text=f"Video duration: {self.timeStr(self.video_duration)}")
        self.redrawTimeline()
        self.clip_selector()

    def extract_clip(self):
        video_path = self.video_path
        file_extension = video_path.suffix
        clip_start = self.clip_start.get()
        clip_end = self.clip_end.get()

        output_path = Path(
            filedialog.asksaveasfilename(
                initialdir=video_path.parent, 
                initialfile=str(
                    f"[Clip] {video_path.stem} ({datetime.timedelta(milliseconds=clip_start)}-{datetime.timedelta(milliseconds=clip_end)}){file_extension}"), 
                title="Select output file", 
                defaultextension=file_extension
            )
        )
        if output_path == Path("."):
            return False
        ffmpeg_command = [
            "ffmpeg",
            "-y", # The output path prompt asks for confirmation before overwriting
            "-hide_banner",
            "-i", str(video_path),
            "-ss", f"{clip_start}ms",
            "-to", f"{clip_end}ms",
            "-map", "0",
            "-c:v", "copy",
            "-c:a", "copy",
            str(output_path),
        ]
        if self.debug_checkvar.get() == 1:
            subprocess.run(ffmpeg_command)
        else:
            subprocess.run(ffmpeg_command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print(f"Finished! Saved to {output_path}")

root = tk.Tk()
app = VideoClipExtractor(root)
root.mainloop()

