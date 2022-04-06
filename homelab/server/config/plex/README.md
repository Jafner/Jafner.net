# Remote Access
To get remote access working, make the following changes:
1. Set `Settings > Remote Access > Manually Specify public port` to `443`
2. Set `Settings > Network > Custom server access URLs` to `https://plex.jafner.net:443`
The settings page may incorrectly report that the server is inaccessible. 

- https://github.com/Jafner/docker_config/blob/master/plex/docker-compose.yml
- https://forums.plex.tv/t/plex-traefik-2-0-2-1-not-available-outside-your-network/521424/3

# LG WebOS TV Video Format Support 
From LG's documentation:

<img src=docs/img/lg_webos_playing_video_files.png width="400">

<img src=docs/img/lg_webos_video_codec.png width="400">

<img src=docs/img/lg_webos_video_playback_supporting_file.png width="400">
