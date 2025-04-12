+++
title = 'Homelab'
description = ' '
date = 2024-05-28T17:58:08-07:00
draft = true
+++

# Preamble: How to Use My Homelab Repo

# Intro
- My homelab is always evolving, so I will aim to keep the contents of this page agnostic to any current setup.
- Always intended to make the repository publicly accessible, but left secrets in the code early on.
- Always pushed toward complete configuration as code. Application data and secrets excepted, all application configuration *should* be defined in the application's config directory.
- Some docker images don't get us 100% of the way there, so we define what we can in the compose file, then either scripts or a README to fill in the gaps.

# Principles and Goals
1. Be useful. First and foremost we should remove anything that isn't useful, and trial anything that may be.
2. Be resilient. We should integrate configuration code with process documentation to make rebuilding from scratch as easy as possible.
3. Be simple.
4. Be helpful. First for myself to make future work easier, and second to make writing this page easier (3 years later).

# Development: Problems and Solutions

## What I've got to work with: Hosts and Cloud Resources
- Barbarian
- Fighter
- Druid
- Wizard
- Monk

## What I need to get done: Service Roles

- I need some way to store a lot of big files. Storing and protecting big library.
- I need some way for my friends and family to watch the movies in my movie library. Serving media library.
- I need some way to make my stuff accessible safely over the internet. Managing access.
- I need some way to manage this whole thing. Managing configuration.
- I need some way to know if it's breaking. Monitoring and notifying on service uptime.

## What I don't need to get done: Retired Service Roles

## The wrong ways to do it: Replaced Services

# Long-Lived Lessons

# Appendix A: Tools Used
Appendix of tools.

## Local Tools
- Docker
- Docker-compose
- Git
- Ansible
- VSCodium
- Terraform
- Tabby

## Services: Chronological

### The Before Times
- Teamspeak 3
- Terraria
- Minecraft
- 5eTools

### Initial Commit
- Wireguard (wg-easy)
- Wikijs
- Uptime-kuma
- Unifi_controller
- Traefik
- Tdarr
- Prometheus
- Wordpress (Portfolio, NVGM, landing)
- Portainer
- Plex
- Peertube
- Olivetin
- Docker-minecraft
- Joplin
- Homer
- Grafana
- InfluxDB
- Telegraf
- Gitlab
- Gitea
- Exatorrent
- PlantUML
- DrawIO
- Cloudflare-DDNS
- Calibre-web
- Authentik
- Ass
- Radarr
- Sonarr
- NZBHydra2
- SabNZBD

## Services: By Category

### Serve Files
- Video: Plex, Peertube, Zipline, Jellyfin
- Image: Ass,
- 3D Models: Vandam (now Manyfold)
- Ebooks: Calibre-web
- Notes: Joplin
- Files: Nextcloud, Send, TrueNAS

### Manage Access (& Other Admin)
- Keycloak
- Authentik
- Wireguard
- Traefik
- Unifi Controller
- DDNS

### Git Server
- Gitlab
- Gitea

### Monitoring & Observability
- Uptime Kuma
- Prometheus
- Grafana
- MC-Monitor
- InfluxDB and Telegraf
- Exporters for Ping, Docker, PiHole, UptimeKuma

### Websites
- NVGM, portfolio, landing
- Wikijs
- Homer, Homepage
- Jafner.dev

### Torrents
- Rtorrent
- Transmission
- Deluge
- ExaTorrent
- Qbittorrent

### Games Servers
- Minecraft
- Unturned
- Terraria
- 7 Days to Die
