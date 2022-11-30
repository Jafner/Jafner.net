# Table of Contents
- [Table of Contents](#table-of-contents)
- [About ffmpeg](#about-ffmpeg)
- [Get Video Info with `mediainfo`](#get-video-info-with-mediainfo)
- [Remux MKV to MP4 with ffmpeg](#remux-mkv-to-mp4-with-ffmpeg)
  - [Adding ffmpeg Scripts to Windows SendTo Menu](#adding-ffmpeg-scripts-to-windows-sendto-menu)
- [Get Test Image with ffmpeg](#get-test-image-with-ffmpeg)
- [Batch-ify ffmpeg Command](#batch-ify-ffmpeg-command)
- [Add Metadata to File](#add-metadata-to-file)
- [Create Slow-mo](#create-slow-mo)
- [Transcode Profiles](#transcode-profiles)
  - [Original \[40.3 Mb/s\]](#original-403-mbs)
    - [Mediainfo](#mediainfo)
    - [Test Image](#test-image)
  - [CRF 21 \[19.9 Mb/s\]](#crf-21-199-mbs)
    - [Mediainfo](#mediainfo-1)
    - [Test Image](#test-image-1)
  - [CRF 27 \[10.3 Mb/s\]](#crf-27-103-mbs)
    - [Mediainfo](#mediainfo-2)
    - [Test Image](#test-image-2)
  - [1080p CRF 21 \[11.9 Mb/s\]](#1080p-crf-21-119-mbs)
    - [Mediainfo](#mediainfo-3)
    - [Test Image](#test-image-3)
  - [1080p CRF 27 \[6,232 kb/s\]](#1080p-crf-27-6232-kbs)
    - [Mediainfo](#mediainfo-4)
    - [Test Image](#test-image-4)
  - [720p CRF 21 \[6,314 kb/s\]](#720p-crf-21-6314-kbs)
    - [Mediainfo](#mediainfo-5)
    - [Test Image](#test-image-5)
  - [720p CRF 27 \[3,305 kb/s\]](#720p-crf-27-3305-kbs)
    - [Mediainfo](#mediainfo-6)
    - [Test Image](#test-image-6)
- [Test a New Profile](#test-a-new-profile)

# About ffmpeg
FFmpeg is a free and open-source software project consisting of a suite of libraries and programs for handling video, audio, and other multimedia files and streams. At its core is the command-line ffmpeg tool itself, designed for processing of video and audio files. [Wikipedia](https://en.wikipedia.org/wiki/FFmpeg). [ffmpeg.org](https://ffmpeg.org/).

# Get Video Info with `mediainfo`
MediaInfo is a free, cross-platform and open-source program that displays technical information about media files, as well as tag information for many audio and video files. [Wikipedia](https://en.wikipedia.org/wiki/MediaInfo).  

To install on Debian, run `sudo apt install mediainfo`. 
To get comprehensive media information about a file, simply use `mediainfo <file>`. 

# Remux MKV to MP4 with ffmpeg
To remux an mkv file to mp4 with ffmpeg, use `ffmpeg -i "$input" -codec copy "$output"`. Note that ffmpeg pays attention to the file extensions, so `$input` should have a `.mkv` extension, and `$output` should have a `.mp4` extension.

## Adding ffmpeg Scripts to Windows SendTo Menu
Inspired by this [Tek Syndicate video](https://www.youtube.com/watch?v=BrbfQqjHE68), we can add arbitrary ffmpeg scripts to Windows' built-in send-to menu. (Note that while it might be prettier to add a new expandable right-click menu, this is [much less trivial](https://superuser.com/questions/444726/windows-how-to-add-batch-script-action-to-right-click-menu/444787#444787)).  

But rather than using Windows Batch Scripting, we're going to use PowerShell, a competent language. This assumes you are using Windows 10.

1. Write the PowerShell script. Example scripts are provided in [scripts/](/docs/attach/scripts/ffmpeg/). 
2. Place the PowerShell script somewhere safe. I place my scripts next to the ffmpeg binary `C:\Users\$user\Programs\ffmpeg\bin\my_script.ps1`.
3. Add a shortcut for the script to Windows' SendTo directory: `Windows + R` to open the Run dialog, then enter `shell:SendTo` and hit enter. In this directory, create a new shortcut. For the "location", enter the location of your PowerShell executable (for me: `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`) and name as you want it to appear in the right-click menu.
4. Fix the shortcut. Right-click your new shortcut, then click "Properties". Change the "Target" to call PowerShell with the `-File` flag with the path of your script in quotes (e.g. Target: `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File "C:\Users\jafne\Programs\ffmpeg\bin\remux.ps1"`). For the example scripts, "Start in" is set to the location of the ffmpeg binary, but that should not be required if ffmpeg is added to your system path. However, if you fail to supply a proper output file path, the working directory will be used. The working directory defaults to the "Start in" directory.

# Get Test Image with ffmpeg
To get the test image, we extract frame of timestamp 15:20.01 from the test video with `ffmpeg -ss 00:15:20.01 -i "$input" -frames:v 1 "$output"`. 

In other situations, we can extract a frame at a specific frame number with `ffmpeg -i "$input" -vf "select=eq(n\,1201)" -vframes 1 "$output"`. Where `1201` indicates we want the 1202nd frame.

# Batch-ify ffmpeg Command
For a given `ffmpeg -i $video <do stuff>`, apply the command to all `.mp4` videos in a directory and send all outputs to `./Transcodes/` with the following structure:
```bash
for video in ./*.mp4
do
    ffmpeg -i "$video" <do stuff> "Transcodes/${video%.*}.mp4"
done
```

# Add Metadata to File
ffmpeg can add metadata to files using the `-metadata` flag. In the profiles described below, this is used to add a comment describing the profile used to create the file (e.g. `-metadata comment="x264 720p CRF 27"`).   

This comment flag is visible in Windows file details.  

![File details](img/ffmpeg/File%20Details.png)

More information: [corbpie.com](https://write.corbpie.com/adding-metadata-to-a-video-or-audio-file-with-ffmpeg/).

# Create Slow-mo
Creating a slow-mo clip is a two-step process. This assumes your input is encoded with h264. 

1. Copy the video to a raw h264 bitstream: `ffmpeg -i "$input" -map 0:v -c:v copy -bsf:v h264_mp4toannexb 'raw.h264'`
2. Generate new timestamps for each frame with `genpts` (generate presentation timestamps): `ffmpeg -fflags +genpts -r 30 -i raw.h264 -c:v copy -movflags faststart "$output"`. The `-r 30` flag sets the new framerate to 30 frames per second, which results in a 0.2x playback rate for a 150 fps input video. Alternatively, use `-r 60` or omit the `-r` flag to get 60 fps, which results in a 0.4x playback rate for a 150 fps input video.
3. Optionally, interpolate motion for the newly slowed video: `ffmpeg -i "$input" -filter:v "minterpolate='mi_mode=mci:mc_mode=aobmc:vsbmc=1:fps=60'" "$output"`. This step runs very slowly. Around 2 fps interpolating from 30 to 60 fps on a Ryzen 7 3700X. This performance issues is [well](https://stackoverflow.com/questions/42385502/ffmpeg-motion-interpolation-alternatives-or-speedup) [documented](http://ffmpeg.org/pipermail/ffmpeg-user/2021-January/051603.html). It is trivial to parallelize processing of multiple clips, as they use little CPU for each process.

Note that these slow-mo files will have no audio.

If you need audio, or just more information, see the [ffmpeg docs](https://trac.ffmpeg.org/wiki/How%20to%20speed%20up%20/%20slow%20down%20a%20video).  

For documentation on interpolation settings, see [minterpolate docs](http://ffmpeg.org/ffmpeg-filters.html#minterpolate)

# Transcode Profiles
## Original [40.3 Mb/s]
The pre-transcode data for the sample video. It was recorded using OBS with the following encoder settings at 1440p60: 

| Parameter | Value |
|:---------:|:-----:|
| Rate Control | CBR |
| Bitrate | 40000 Kbps |
| Keyframe interval | 0s (auto) |
| Preset | Quality |
| Profile | high |
| Look-ahead | Yes |
| Psycho Visual Tuning | Yes |
| GPU | Nvidia RTX 3060 Ti |
| Max B-Frames | 2 |

### Mediainfo
```
General
Complete name                            : ffmpeg test file.mp4
Format                                   : MPEG-4
Format profile                           : Base Media
Codec ID                                 : isom (isom/iso2/avc1/mp41)
File size                                : 4.57 GiB
Duration                                 : 16 min 12 s
Overall bit rate mode                    : Constant
Overall bit rate                         : 40.3 Mb/s
Writing application                      : Lavf59.16.100

Video
ID                                       : 1
Format                                   : AVC
Format/Info                              : Advanced Video Codec
Format profile                           : High@L5.1
Format settings                          : CABAC / 4 Ref Frames
Format settings, CABAC                   : Yes
Format settings, Reference frames        : 4 frames
Codec ID                                 : avc1
Codec ID/Info                            : Advanced Video Coding
Duration                                 : 16 min 12 s
Source duration                          : 16 min 12 s
Bit rate mode                            : Constant
Bit rate                                 : 40.0 Mb/s
Width                                    : 2 560 pixels
Height                                   : 1 440 pixels
Display aspect ratio                     : 16:9
Frame rate mode                          : Variable
Frame rate                               : 60.000 FPS
Minimum frame rate                       : 58.824 FPS
Maximum frame rate                       : 62.500 FPS
Color space                              : YUV
Chroma subsampling                       : 4:2:0
Bit depth                                : 8 bits
Scan type                                : Progressive
Bits/(Pixel*Frame)                       : 0.181
Stream size                              : 4.53 GiB (99%)
Source stream size                       : 4.53 GiB (99%)
Color range                              : Limited
Color primaries                          : BT.709
Transfer characteristics                 : BT.709
Matrix coefficients                      : BT.709
mdhd_Duration                            : 972666
Codec configuration box                  : avcC

Audio
ID                                       : 2
Format                                   : AAC LC
Format/Info                              : Advanced Audio Codec Low Complexity
Codec ID                                 : mp4a-40-2
Duration                                 : 16 min 12 s
Bit rate mode                            : Constant
Bit rate                                 : 318 kb/s
Channel(s)                               : 2 channels
Channel layout                           : L R
Sampling rate                            : 48.0 kHz
Frame rate                               : 46.875 FPS (1024 SPF)
Compression mode                         : Lossy
Stream size                              : 36.9 MiB (1%)
Title                                    : Track1
Default                                  : Yes
Alternate group                          : 1
```

### Test Image

![Test Image - Original](img/ffmpeg/original.png)

## CRF 21 [19.9 Mb/s]
`ffmpeg -i "$input" -metadata comment="x264 CRF 21" -movflags +faststart -c:v libx264 -preset slower -crf 21 "$output"`

### Mediainfo
```
General
Complete name                            : CRF 21.mp4
Format                                   : MPEG-4
Format profile                           : Base Media
Codec ID                                 : isom (isom/iso2/avc1/mp41)
File size                                : 2.25 GiB
Duration                                 : 16 min 12 s
Overall bit rate                         : 19.9 Mb/s
Writing application                      : Lavf58.45.100

Video
ID                                       : 1
Format                                   : AVC
Format/Info                              : Advanced Video Codec
Format profile                           : High@L5.1
Format settings                          : CABAC / 8 Ref Frames
Format settings, CABAC                   : Yes
Format settings, Reference frames        : 8 frames
Codec ID                                 : avc1
Codec ID/Info                            : Advanced Video Coding
Duration                                 : 16 min 12 s
Bit rate                                 : 19.8 Mb/s
Width                                    : 2 560 pixels
Height                                   : 1 440 pixels
Display aspect ratio                     : 16:9
Frame rate mode                          : Constant
Frame rate                               : 60.000 FPS
Color space                              : YUV
Chroma subsampling                       : 4:2:0
Bit depth                                : 8 bits
Scan type                                : Progressive
Bits/(Pixel*Frame)                       : 0.089
Stream size                              : 2.24 GiB (99%)
Writing library                          : x264 core 160 r3011 cde9a93
Encoding settings                        : cabac=1 / ref=8 / deblock=1:0:0 / analyse=0x3:0x133 / me=umh / subme=9 / psy=1 / psy_rd=1.00:0.00 / mixed_ref=1 / me_range=16 / chroma_me=1 / trellis=2 / 8x8dct=1 / cqm=0 / deadzone=21,11 / fast_pskip=1 / chroma_qp_offset=-2 / threads=24 / lookahead_threads=2 / sliced_threads=0 / nr=0 / decimate=1 / interlaced=0 / bluray_compat=0 / constrained_intra=0 / bframes=3 / b_pyramid=2 / b_adapt=2 / b_bias=0 / direct=3 / weightb=1 / open_gop=0 / weightp=2 / keyint=250 / keyint_min=25 / scenecut=40 / intra_refresh=0 / rc_lookahead=60 / rc=crf / mbtree=1 / crf=21.0 / qcomp=0.60 / qpmin=0 / qpmax=69 / qpstep=4 / ip_ratio=1.40 / aq=1:1.00
Codec configuration box                  : avcC

Audio
ID                                       : 2
Format                                   : AAC LC
Format/Info                              : Advanced Audio Codec Low Complexity
Codec ID                                 : mp4a-40-2
Duration                                 : 16 min 12 s
Bit rate mode                            : Constant
Bit rate                                 : 129 kb/s
Channel(s)                               : 2 channels
Channel layout                           : L R
Sampling rate                            : 48.0 kHz
Frame rate                               : 46.875 FPS (1024 SPF)
Compression mode                         : Lossy
Stream size                              : 14.9 MiB (1%)
Default                                  : Yes
Alternate group                          : 1
```

### Test Image

![Test Image - CRF 21](img/ffmpeg/CRF%2021.png)

## CRF 27 [10.3 Mb/s]
`ffmpeg -i "$input" -metadata comment="x264 CRF 27" -movflags +faststart -c:v libx264 -preset slower -crf 27 "$output"`

### Mediainfo 
```
General
Complete name                            : CRF 27.mp4
Format                                   : MPEG-4
Format profile                           : Base Media
Codec ID                                 : isom (isom/iso2/avc1/mp41)
File size                                : 1.17 GiB
Duration                                 : 16 min 12 s
Overall bit rate                         : 10.3 Mb/s
Writing application                      : Lavf59.9.102

Video
ID                                       : 1
Format                                   : AVC
Format/Info                              : Advanced Video Codec
Format profile                           : High@L5.1
Format settings                          : CABAC / 8 Ref Frames
Format settings, CABAC                   : Yes
Format settings, Reference frames        : 8 frames
Codec ID                                 : avc1
Codec ID/Info                            : Advanced Video Coding
Duration                                 : 16 min 12 s
Bit rate                                 : 10.2 Mb/s
Width                                    : 2 560 pixels
Height                                   : 1 440 pixels
Display aspect ratio                     : 16:9
Frame rate mode                          : Constant
Frame rate                               : 60.000 FPS
Color space                              : YUV
Chroma subsampling                       : 4:2:0
Bit depth                                : 8 bits
Scan type                                : Progressive
Bits/(Pixel*Frame)                       : 0.046
Stream size                              : 1.15 GiB (99%)
Writing library                          : x264 core 164 r3075 66a5bc1
Encoding settings                        : cabac=1 / ref=8 / deblock=1:0:0 / analyse=0x3:0x133 / me=umh / subme=9 / psy=1 / psy_rd=1.00:0.00 / mixed_ref=1 / me_range=16 / chroma_me=1 / trellis=2 / 8x8dct=1 / cqm=0 / deadzone=21,11 / fast_pskip=1 / chroma_qp_offset=-2 / threads=24 / lookahead_threads=2 / sliced_threads=0 / nr=0 / decimate=1 / interlaced=0 / bluray_compat=0 / constrained_intra=0 / bframes=3 / b_pyramid=2 / b_adapt=2 / b_bias=0 / direct=3 / weightb=1 / open_gop=0 / weightp=2 / keyint=250 / keyint_min=25 / scenecut=40 / intra_refresh=0 / rc_lookahead=60 / rc=crf / mbtree=1 / crf=27.0 / qcomp=0.60 / qpmin=0 / qpmax=69 / qpstep=4 / ip_ratio=1.40 / aq=1:1.00
Color range                              : Limited
Color primaries                          : BT.709
Transfer characteristics                 : BT.709
Matrix coefficients                      : BT.709
Codec configuration box                  : avcC

Audio
ID                                       : 2
Format                                   : AAC LC
Format/Info                              : Advanced Audio Codec Low Complexity
Codec ID                                 : mp4a-40-2
Duration                                 : 16 min 12 s
Source duration                          : 16 min 12 s
Bit rate mode                            : Constant
Bit rate                                 : 132 kb/s
Channel(s)                               : 2 channels
Channel layout                           : L R
Sampling rate                            : 48.0 kHz
Frame rate                               : 46.875 FPS (1024 SPF)
Compression mode                         : Lossy
Stream size                              : 15.2 MiB (1%)
Source stream size                       : 15.2 MiB (1%)
Default                                  : Yes
Alternate group                          : 1
mdhd_Duration                            : 972629
```

### Test Image

![Test Image - CRF 27](img/ffmpeg/CRF%2027.png)

## 1080p CRF 21 [11.9 Mb/s]
`ffmpeg -i "$input" -metadata comment="x264 1080p CRF 21" -movflags +faststart -vf scale=1920:1080 -c:v libx264 -preset slower -crf 21 "$output"`

### Mediainfo
```
General
Complete name                            : 1080p CRF 21.mp4
Format                                   : MPEG-4
Format profile                           : Base Media
Codec ID                                 : isom (isom/iso2/avc1/mp41)
File size                                : 1.35 GiB
Duration                                 : 16 min 12 s
Overall bit rate                         : 11.9 Mb/s
Writing application                      : Lavf58.45.100

Video
ID                                       : 1
Format                                   : AVC
Format/Info                              : Advanced Video Codec
Format profile                           : High@L5
Format settings                          : CABAC / 8 Ref Frames
Format settings, CABAC                   : Yes
Format settings, Reference frames        : 8 frames
Codec ID                                 : avc1
Codec ID/Info                            : Advanced Video Coding
Duration                                 : 16 min 12 s
Bit rate                                 : 11.8 Mb/s
Width                                    : 1 920 pixels
Height                                   : 1 080 pixels
Display aspect ratio                     : 16:9
Frame rate mode                          : Constant
Frame rate                               : 60.000 FPS
Color space                              : YUV
Chroma subsampling                       : 4:2:0
Bit depth                                : 8 bits
Scan type                                : Progressive
Bits/(Pixel*Frame)                       : 0.095
Stream size                              : 1.33 GiB (99%)
Writing library                          : x264 core 160 r3011 cde9a93
Encoding settings                        : cabac=1 / ref=8 / deblock=1:0:0 / analyse=0x3:0x133 / me=umh / subme=9 / psy=1 / psy_rd=1.00:0.00 / mixed_ref=1 / me_range=16 / chroma_me=1 / trellis=2 / 8x8dct=1 / cqm=0 / deadzone=21,11 / fast_pskip=1 / chroma_qp_offset=-2 / threads=24 / lookahead_threads=2 / sliced_threads=0 / nr=0 / decimate=1 / interlaced=0 / bluray_compat=0 / constrained_intra=0 / bframes=3 / b_pyramid=2 / b_adapt=2 / b_bias=0 / direct=3 / weightb=1 / open_gop=0 / weightp=2 / keyint=250 / keyint_min=25 / scenecut=40 / intra_refresh=0 / rc_lookahead=60 / rc=crf / mbtree=1 / crf=21.0 / qcomp=0.60 / qpmin=0 / qpmax=69 / qpstep=4 / ip_ratio=1.40 / aq=1:1.00
Codec configuration box                  : avcC

Audio
ID                                       : 2
Format                                   : AAC LC
Format/Info                              : Advanced Audio Codec Low Complexity
Codec ID                                 : mp4a-40-2
Duration                                 : 16 min 12 s
Bit rate mode                            : Constant
Bit rate                                 : 129 kb/s
Channel(s)                               : 2 channels
Channel layout                           : L R
Sampling rate                            : 48.0 kHz
Frame rate                               : 46.875 FPS (1024 SPF)
Compression mode                         : Lossy
Stream size                              : 14.9 MiB (1%)
Default                                  : Yes
Alternate group                          : 1
```

### Test Image

![Test Image - 1080p CRF 21](img/ffmpeg/1080p%20CRF%2021.png)

## 1080p CRF 27 [6,232 kb/s]
`ffmpeg -i "$input" -metadata comment="x264 1080p CRF 27" -movflags +faststart -vf scale=1920:1080 -c:v libx264 -preset slower -crf 27 "$output"`
Our test file described in the [Get Video Info](#get-video-info-with-mediainfo) section was compressed from 40.5 Mbps (over 16m12s) to 

### Mediainfo
```
General
Complete name                            : ffmpeg test file - 1080p crf 27.mp4
Format                                   : MPEG-4
Format profile                           : Base Media
Codec ID                                 : isom (isom/iso2/avc1/mp41)
File size                                : 723 MiB
Duration                                 : 16 min 12 s
Overall bit rate                         : 6 232 kb/s
Writing application                      : Lavf58.45.100

Video
ID                                       : 1
Format                                   : AVC
Format/Info                              : Advanced Video Codec
Format profile                           : High@L5
Format settings                          : CABAC / 8 Ref Frames
Format settings, CABAC                   : Yes
Format settings, Reference frames        : 8 frames
Codec ID                                 : avc1
Codec ID/Info                            : Advanced Video Coding
Duration                                 : 16 min 12 s
Bit rate                                 : 6 089 kb/s
Width                                    : 1 920 pixels
Height                                   : 1 080 pixels
Display aspect ratio                     : 16:9
Frame rate mode                          : Constant
Frame rate                               : 60.000 FPS
Color space                              : YUV
Chroma subsampling                       : 4:2:0
Bit depth                                : 8 bits
Scan type                                : Progressive
Bits/(Pixel*Frame)                       : 0.049
Stream size                              : 706 MiB (98%)
Writing library                          : x264 core 160 r3011 cde9a93
Encoding settings                        : cabac=1 / ref=8 / deblock=1:0:0 / analyse=0x3:0x133 / me=umh / subme=9 / psy=1 / psy_rd=1.00:0.00 / mixed_ref=1 / me_range=16 / chroma_me=1 / trellis=2 / 8x8dct=1 / cqm=0 / deadzone=21,11 / fast_pskip=1 / chroma_qp_offset=-2 / threads=24 / lookahead_threads=2 / sliced_threads=0 / nr=0 / decimate=1 / interlaced=0 / bluray_compat=0 / constrained_intra=0 / bframes=3 / b_pyramid=2 / b_adapt=2 / b_bias=0 / direct=3 / weightb=1 / open_gop=0 / weightp=2 / keyint=250 / keyint_min=25 / scenecut=40 / intra_refresh=0 / rc_lookahead=60 / rc=crf / mbtree=1 / crf=27.0 / qcomp=0.60 / qpmin=0 / qpmax=69 / qpstep=4 / ip_ratio=1.40 / aq=1:1.00
Codec configuration box                  : avcC

Audio
ID                                       : 2
Format                                   : AAC LC
Format/Info                              : Advanced Audio Codec Low Complexity
Codec ID                                 : mp4a-40-2
Duration                                 : 16 min 12 s
Bit rate mode                            : Constant
Bit rate                                 : 129 kb/s
Channel(s)                               : 2 channels
Channel layout                           : L R
Sampling rate                            : 48.0 kHz
Frame rate                               : 46.875 FPS (1024 SPF)
Compression mode                         : Lossy
Stream size                              : 14.9 MiB (2%)
Default                                  : Yes
Alternate group                          : 1

```

### Test Image
![Test Image - 1080p CRF 27](img/ffmpeg/1080p%20crf%2027.png)


## 720p CRF 21 [6,314 kb/s]
`ffmpeg -i "$input" -metadata comment="x264 720p CRF 21" -movflags +faststart -vf scale=1280:720 -c:v libx264 -preset slower -crf 21 "$output"`

### Mediainfo
```
General
Complete name                            : 720p CRF 21.mp4
Format                                   : MPEG-4
Format profile                           : Base Media
Codec ID                                 : isom (isom/iso2/avc1/mp41)
File size                                : 732 MiB
Duration                                 : 16 min 12 s
Overall bit rate                         : 6 314 kb/s
Writing application                      : Lavf59.9.102

Video
ID                                       : 1
Format                                   : AVC
Format/Info                              : Advanced Video Codec
Format profile                           : High@L4
Format settings                          : CABAC / 8 Ref Frames
Format settings, CABAC                   : Yes
Format settings, Reference frames        : 8 frames
Codec ID                                 : avc1
Codec ID/Info                            : Advanced Video Coding
Duration                                 : 16 min 12 s
Bit rate                                 : 6 169 kb/s
Width                                    : 1 280 pixels
Height                                   : 720 pixels
Display aspect ratio                     : 16:9
Frame rate mode                          : Constant
Frame rate                               : 60.000 FPS
Color space                              : YUV
Chroma subsampling                       : 4:2:0
Bit depth                                : 8 bits
Scan type                                : Progressive
Bits/(Pixel*Frame)                       : 0.112
Stream size                              : 715 MiB (98%)
Writing library                          : x264 core 164 r3075 66a5bc1
Encoding settings                        : cabac=1 / ref=8 / deblock=1:0:0 / analyse=0x3:0x133 / me=umh / subme=9 / psy=1 / psy_rd=1.00:0.00 / mixed_ref=1 / me_range=16 / chroma_me=1 / trellis=2 / 8x8dct=1 / cqm=0 / deadzone=21,11 / fast_pskip=1 / chroma_qp_offset=-2 / threads=22 / lookahead_threads=1 / sliced_threads=0 / nr=0 / decimate=1 / interlaced=0 / bluray_compat=0 / constrained_intra=0 / bframes=3 / b_pyramid=2 / b_adapt=2 / b_bias=0 / direct=3 / weightb=1 / open_gop=0 / weightp=2 / keyint=250 / keyint_min=25 / scenecut=40 / intra_refresh=0 / rc_lookahead=60 / rc=crf / mbtree=1 / crf=21.0 / qcomp=0.60 / qpmin=0 / qpmax=69 / qpstep=4 / ip_ratio=1.40 / aq=1:1.00
Color range                              : Limited
Color primaries                          : BT.709
Transfer characteristics                 : BT.709
Matrix coefficients                      : BT.709
Codec configuration box                  : avcC

Audio
ID                                       : 2
Format                                   : AAC LC
Format/Info                              : Advanced Audio Codec Low Complexity
Codec ID                                 : mp4a-40-2
Duration                                 : 16 min 12 s
Source duration                          : 16 min 12 s
Bit rate mode                            : Constant
Bit rate                                 : 132 kb/s
Channel(s)                               : 2 channels
Channel layout                           : L R
Sampling rate                            : 48.0 kHz
Frame rate                               : 46.875 FPS (1024 SPF)
Compression mode                         : Lossy
Stream size                              : 15.2 MiB (2%)
Source stream size                       : 15.2 MiB (2%)
Default                                  : Yes
Alternate group                          : 1
mdhd_Duration                            : 972629
```

### Test Image

![Test Image - 720p CRF 21](img/ffmpeg/720p%20CRF%2021.png)

## 720p CRF 27 [3,305 kb/s]
`ffmpeg -i "$input" -metadata comment="x264 720p CRF 27" -movflags +faststart -vf scale=1280:720 -c:v libx264 -preset slower -crf 27 "$output"`

### Mediainfo
```
General
Complete name                            : 720p CRF 27.mp4
Format                                   : MPEG-4
Format profile                           : Base Media
Codec ID                                 : isom (isom/iso2/avc1/mp41)
File size                                : 383 MiB
Duration                                 : 16 min 12 s
Overall bit rate                         : 3 305 kb/s
Writing application                      : Lavf58.45.100

Video
ID                                       : 1
Format                                   : AVC
Format/Info                              : Advanced Video Codec
Format profile                           : High@L4
Format settings                          : CABAC / 8 Ref Frames
Format settings, CABAC                   : Yes
Format settings, Reference frames        : 8 frames
Codec ID                                 : avc1
Codec ID/Info                            : Advanced Video Coding
Duration                                 : 16 min 12 s
Bit rate                                 : 3 162 kb/s
Width                                    : 1 280 pixels
Height                                   : 720 pixels
Display aspect ratio                     : 16:9
Frame rate mode                          : Constant
Frame rate                               : 60.000 FPS
Color space                              : YUV
Chroma subsampling                       : 4:2:0
Bit depth                                : 8 bits
Scan type                                : Progressive
Bits/(Pixel*Frame)                       : 0.057
Stream size                              : 367 MiB (96%)
Writing library                          : x264 core 160 r3011 cde9a93
Encoding settings                        : cabac=1 / ref=8 / deblock=1:0:0 / analyse=0x3:0x133 / me=umh / subme=9 / psy=1 / psy_rd=1.00:0.00 / mixed_ref=1 / me_range=16 / chroma_me=1 / trellis=2 / 8x8dct=1 / cqm=0 / deadzone=21,11 / fast_pskip=1 / chroma_qp_offset=-2 / threads=22 / lookahead_threads=1 / sliced_threads=0 / nr=0 / decimate=1 / interlaced=0 / bluray_compat=0 / constrained_intra=0 / bframes=3 / b_pyramid=2 / b_adapt=2 / b_bias=0 / direct=3 / weightb=1 / open_gop=0 / weightp=2 / keyint=250 / keyint_min=25 / scenecut=40 / intra_refresh=0 / rc_lookahead=60 / rc=crf / mbtree=1 / crf=27.0 / qcomp=0.60 / qpmin=0 / qpmax=69 / qpstep=4 / ip_ratio=1.40 / aq=1:1.00
Codec configuration box                  : avcC

Audio
ID                                       : 2
Format                                   : AAC LC
Format/Info                              : Advanced Audio Codec Low Complexity
Codec ID                                 : mp4a-40-2
Duration                                 : 16 min 12 s
Bit rate mode                            : Constant
Bit rate                                 : 129 kb/s
Channel(s)                               : 2 channels
Channel layout                           : L R
Sampling rate                            : 48.0 kHz
Frame rate                               : 46.875 FPS (1024 SPF)
Compression mode                         : Lossy
Stream size                              : 14.9 MiB (4%)
Default                                  : Yes
Alternate group                          : 1
```
### Test Image

![Test Image - 720p CRF 27](img/ffmpeg/720p%20CRF%2027.png)

# Test a New Profile
0. Name the profile. `profile="<profile name>"` (E.g. "720p CRF 21")
1. Transcode the file. `ffmpeg -i "original.mp4" <transcode settings> "$profile.mp4"`
2. Extract sample frame from transcoded file. `ffmpeg -ss 00:15:20.01 -i "$profile.mp4" -frames:v 1 "$profile.png"`
3. Print media info for the new file. `mediainfo "$profile.mp4"`
4. Update this doc!