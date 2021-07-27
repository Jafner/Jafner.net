---
title: Plex
description: Configuration information for Plex and sidecar containers
published: true
date: 2021-07-27T17:53:22.783Z
tags: 
editor: markdown
dateCreated: 2021-07-27T17:53:22.783Z
---

# Remote Access
To get remote access working, make the following changes:
1. Set `Settings > Remote Access > Manually Specify public port` to `443`
2. Set `Settings > Network > Custom server access URLs` to `https://plex.jafner.net:443`
The settings page may incorrectly report that the server is inaccessible. 
https://github.com/Jafner/docker_config/blob/master/plex/docker-compose.yml
https://forums.plex.tv/t/plex-traefik-2-0-2-1-not-available-outside-your-network/521424/3
