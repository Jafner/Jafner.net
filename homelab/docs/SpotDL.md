# Basic Usage
To download a track, album, or artist from Spotify, use:
`spotdl <url e.g. https://open.spotify.com/artist/3q7HBObVc0L8jNeTe5Gofh?si=fd6100828a764c3b>`

This is non-interactive and works programmatically.

# Music Library Integration
To make updating my library easier, each "Artist" folder has a file called `spot.txt` which contains only the Spotify URL for that artist. This makes it possible to run a loop similar to the following:

```sh
cd /path/to/music/library/artists
for artist in */; do
  cd "$(pwd)/$artist" && 
  spotdl $(cat spot.txt) &&
  cd ..
done
```

# Links
[coritsky/spotdl on Dockerhub](https://hub.docker.com/r/coritsky/spotdl)
[Spotdl on GitHub](https://github.com/spotDL/spotify-downloader/)