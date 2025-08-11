---
title: I spun-up a Minecraft server with my phone in a WinCo parking lot
description: "An article walking through the tools and workflows I use to abridge the setup of a Minecraft server to a few minutes of typing on my phone. "
date: 2025-06-18
updated: 2025-06-18
tags: self-hosting,docker,minecraft
slug: parking-lot-minecraft-server
---

- Friend messaged me on Discord.
- Opened Dockge and started a new stack.
- Added Itzg's images for `mc-router` and `minecraft-server`.
- Added Caddy labels to redirect web traffic to mcstatus.

Features:

- Reverse-proxied to an easy-to-speak address (`mc.jafner.net`).
- All yaml configuration. No SSH. No `.env` files.
- Uptime monitoring, downtime notifications, and web traffic redirection to [mcstatus.io](https://mcstatus.io).
- Easy to expand to additional servers.

---

minecraft compose file

```yml
services:
  vanilla:
    container_name: vanilla
    image: itzg/minecraft-server:latest
    networks:
      - minecraft
    environment:
      EULA: "TRUE"
    labels:
      mc-router.host: mc.jafner.dev
      mc-router.port: "25565"
      mc-router.network: minecraft
      mc-router.default: true
      caddy: mc.jafner.dev
      caddy.redir: https://mcstatus.io/status/java/mc.jafner.dev
  router:
    image: itzg/mc-router:latest
    container_name: router
    networks:
      - minecraft
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      IN_DOCKER: true
    ports:
      - 25565:25565
networks:
  minecraft:
    name: minecraft
x-docs:
  urls:
    - https://github.com/itzg/mc-router
    - https://docker-minecraft-server.readthedocs.io/en/latest/
```

caddy compose file

```yml
services:
  caddy:
    image: lucaslorentz/caddy-docker-proxy:ci-alpine
    container_name: caddy
    restart: unless-stopped
    networks:
      - caddy
    ports:
      - 80:80
      - 443:443
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /appdata/caddy/data:/data
    environment:
      - CADDY_INGRESS_NETWORKS=caddy
    labels:
      caddy_0.email: "joey@jafner.net"

networks:
  caddy:
    name: caddy
```
