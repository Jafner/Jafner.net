import av

with av.open("TestClips/x264Source.mkv") as container:
    frame_num = 622
    time_base = container.streams.video[0].time_base
    framerate = container.streams.video[0].average_rate
    timestamp = frame_num/framerate
    rounded_pts = round((frame_num / framerate) / time_base)
    print(f"Variables:\n\
        frame_num: {frame_num} (type: {type(frame_num)}\n\
        time_base: {time_base} (type: {type(time_base)}\n\
        timestamp: {timestamp} (type: {type(timestamp)}\n\
        frame_num / framerate: {frame_num / framerate}\n\
        frame_num / time_base: {frame_num / time_base}\n\
        (frame_num / framerate) / time_base: {(frame_num / framerate) / time_base}\n\
        rounded_pts = {rounded_pts}\
    ")
    
    container.seek(rounded_pts, backward=True, stream=container.streams.video[0])
    frame = next(container.decode(video=0))
    frame.to_image().save("TestClips/Thumbnail3.jpg".format(frame.pts), quality=80)