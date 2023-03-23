# Remote Access
To get remote access working, make the following changes:
1. Set `Settings > Remote Access > Manually Specify public port` to `443`
2. Set `Settings > Network > Custom server access URLs` to `https://plex.jafner.net:443`
The settings page may incorrectly report that the server is inaccessible. 

- https://github.com/Jafner/docker_config/blob/master/plex/docker-compose.yml
- https://forums.plex.tv/t/plex-traefik-2-0-2-1-not-available-outside-your-network/521424/3

# LG WebOS TV Video Format Support 
From LG's documentation:

<img src=docs/img/lg_webos_playing_video_files.png width="600">

<img src=docs/img/lg_webos_video_codec.png width="600">

<img src=docs/img/lg_webos_video_playback_supporting_file.png width="600">

# Fixing Plex Exporter
When Plex is restarted you will likely need to give the exporter a new Plex token so it can connect to Plex. 

1. Open [Plex](https://plex.jafner.net).
2. Log into any account.
3. Select a locally-hosted piece of media (any media). Open the information page for that media, you do not need to play it. 
4. From the triple-dot menu for the media, click "Get Info" to open the Media Info panel. 
5. At the bottom right of the Media Info panel, click "View XML".
6. The Plex token is contained in the URL for the XML page. It should be at the very end of the URL, and look like `X-Plex-Token=***REMOVED***`. The token is the part after the `=`. 
7. Copy that value. Paste it into the configuration for `"--token=<token-goes-here>"` under the `command:` section of the `docker-compose.yml`
8. Sync the changes via git.
9. Restart Plex exporter with `docker-compose up -d --force-recreate exporter_plex`


https://github.com/arnarg/plex_exporter
https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/