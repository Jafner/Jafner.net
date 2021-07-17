---
title: Untitled Page
description: 
published: true
date: 2021-07-17T05:14:09.814Z
tags: 
editor: markdown
dateCreated: 2021-07-17T04:18:52.299Z
---

# Home


# Adding a Service to Traefik
Add the following snippets to the `docker-compose.yml` for a service to add it to the Traefik network.

```yml
services:
	<service>:
  	networks:
    	-	web
    labels:
    	# set <service> to the name of the service
      # <subdomain> must be unique on the Traefik network
    	- traefik.http.routers.<service>.rule=Host(`<subdomain>.jafner.net`)
      # this is required for TLS certificates
      - traefik.http.routers.<service>.tls.certresolver=lets-encrypt
      # this is only required if Traefik's default port selection fails
      -	traefik.http.services.<service>.loadbalancer.server.port=<port>
      # this is used to protect the service behind Authelia SSO
      - traefik.http.routers.<service>.middlewares=authelia@file
networks:
	web:
  	external: true
```

# Copying SSH Keys to New Host
From: [ssh.com](https://www.ssh.com/academy/ssh/copy-id)
1. Open Powershell on desktop, then `cd ~/.ssh/`
2. Run `ssh-copy-id -i <my_key> <remoteuser>@<remotehost>` to copy the <my_key> file to the new host.
3. Add the new host to Terminus. 