# UI
- Allow clip end to ignore keyframes. (Ignore step size too?)
- Create popup message for long loading times (getting keyframes, extracting clip)
- Create some notification for clip complete.
- Handle video resizing
- Input box for clip start and end times. 
- Timeline zoom for better handling of long vods. 
- Move clip start label to left of timeline. Clip end label to right.
- Add tab for console output.
- Replace `H:MM:SS.ms` time string format with `H:MM:SS (n)`, where `n` is the frame since last keyframe. Clip start will always have an `n` of `0`, so it can be omitted.

# FFMPEG
- ~~Ensure extraction does not lose audio or video streams.~~ Fixed via `-map 0` in extract function.
- ~~PREVIEW. Figure out how to play the video segment in the preview panel.~~
- ~~Currently only supports AV1 mkv video.~~ Now supports whatever the locally installed `ffplay` can handle.
- Figure out how to print video info to info tab.
- Figure out how to overlay keyboard interface info onto video.
- Diagnose 'TRANSCODED.mp4' appears to have only one keyframe.
- Test seek performance with `-ss` pre-`-i` vs. post `-i`. [ffmpeg - seeking](https://trac.ffmpeg.org/wiki/Seeking).

# Design
- Job queue. 
- Run from file explorer context menu. (Right click file, open with: Clip)
- Create and populate a video info tab. Codecs, duration, resolution and framerate, bitrate, etc.
- Handle case where video file has bad keyframes (e.g. only keyframe at start.)
- Implement logging.
- ~~Handle file overwrite with prompt.~~

# Long-Term
- Implement testing; unit, perf.
- Implement build pipeline.
- Re-implement the range slider to more precisely target our use case.
    - Start adheres to steps, end ignores steps.
    - Implement use of the `.bind()` method from [Tkinter Scale](https://tkdocs.com/pyref/scale.html) to trigger callback only when slider is released (reduce computational load). [StackOverflow](https://stackoverflow.com/questions/3966303/tkinter-slider-how-to-trigger-the-event-only-when-the-iteraction-is-complete). 
- Re-implement the preview player without ffmpeg, or integrate ffmpeg window into preview pane.

# Resources
- [Tkinter Tabs](https://www.geeksforgeeks.org/creating-tabbed-widget-with-python-tkinter/)
