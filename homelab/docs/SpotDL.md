# Basic Usage
First, the program must be downloaded with `pip3` (requires Python 3.6.1 `sudo apt install python3` or higher *and* FFmpeg 4.2 `sudo apt install ffmpeg` or higher) via `pip3 install spotdl`.

To download a track, album, or artist from Spotify, use:
`spotdl <url e.g. https://open.spotify.com/artist/3q7HBObVc0L8jNeTe5Gofh?si=fd6100828a764c3b>`

This is non-interactive and works programmatically.

## Using Docker Container
If the host has Docker, but you don't want to install any Python packages, you can run single commands with the Docker container with `docker run --rm -it -v "$(pwd):/data" coritsky/spotdl <url e.g. https://open.spotify.com/artist/3q7HBObVc0L8jNeTe5Gofh?si=fd6100828a764c3b>`.

# Music Library Integration
To make updating my library easier, each "Artist" folder has a file called `spot.txt` which contains only the Spotify URL for that artist. This makes it possible to run a loop similar to the following:

```sh
cd /path/to/music/library/artists
for artist in */; do
  cd "$(pwd)/$artist" && 
  # use spotdl if the host is already configured with spotdl, or you don't need the script to be portable
  # use docker run for better portability (within my lab) at the expense of overhead
  spotdl $(cat spot.txt) && 
  # docker run --rm -it -v "$(pwd):/data" coritsky/spotdl $(cat spot.txt) &&
  cd ..
done
```

# Links
[coritsky/spotdl on Dockerhub](https://hub.docker.com/r/coritsky/spotdl)
[Spotdl on GitHub](https://github.com/spotDL/spotify-downloader/)