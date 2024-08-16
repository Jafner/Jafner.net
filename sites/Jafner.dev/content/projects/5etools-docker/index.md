+++
title = '5eTools Docker: Admin-friendly 5eTools Docker image'
description = " "
date = 2024-07-21T11:55:06-07:00
aliases = []
author = "Joey Hafner"
ogimage = '/img/Jafner.dev.logo.png'
slug = "5etools"
draft = true
+++

## The What and Why
I initially created `5etools-docker` when I wanted to host my own instance and there was no publicly-available Docker image available to facilitate that. That was back before there was a Git repo for it, so we had to check a site. For liability reasons, I couldn't build the image with the site files inside it, so instead I went with an installer/updater script approach. 

The image and script were pretty much it. Just a little 3rd-party Dockerization of a site I wanted to self-host. 

And then the Git repo was published and a two-line Dockerfile obsoleted my work. A perfect opportunity to look for ways to provide differentiating features: automatically import homebrew and blocklist files. 

5eTools self-hosted instances offer the ability to customize your instance by automatically loading a list of homebrew content. For me, that means I can spin up an instance pre-loaded with my custom homebrew and my players can access that content seamlessly. And that same feature supports blocklists, so I can just disable all the content I don't own, or don't want my players to use. Cool stuff!

So how can we get a 5eTools instance that provides the features I want as a DM?

- Auto-updating from the upstream repository. 
- Auto-loading my homebrew.
- Auto-loading my blocklist of content I don't own.

Let's dig into it.

## The How
I built this image in three parts, each working at a different in the deployment process:

- `Dockerfile`
- `docker-compose.yaml`
- `init.sh`

Our `Dockerfile` provides the core packages and utilities we need to run the web server and handle automatic updating. It's based on `httpd`, just like the upstream. But it also provides some features useful to admins integrating 5eTools into a bigger Docker environment: PUID and PGID settings with directory ownership assertion, the `curl`, `git`, and `jq` packages, and of course the `init.sh` script. 

The `docker-compose.yaml` file is a declarative configuration version of a `docker run` command. In addition to the standard benefits of declarative configuration, we can also include some basic usage documentation inside the file for things like envrionment variables and volume mounts. 

And finally, `init.sh` runs every time you launch the container. It handles any runtime logic and features we've implemented: offline mode, auto-updating, include or skip image files, and homebrew/blocklist patching.  

### Dead Simple Dockerfile
The core of our image, it pulls the fewest possible packages necessary to run our script. 

### Init Script

### Docker Compose

### Usage

## Closing Thoughts and Future Work