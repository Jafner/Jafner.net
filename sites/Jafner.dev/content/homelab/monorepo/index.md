---
title = 'Monorepo'
description = " "
date = 2024-07-17T10:23:25-07:00
aliases = []
author = "Joey Hafner"
ogimage = '/img/Jafner.dev.logo.png'
slug = "draft"
draft = true
---

## How to consolidate disparate repos into a monorepo.

### What is a monorepo? 
And why would I want it?

*An illustration of the issue*
![graphic design is my passion](monorepo.png)

### Grabbing all the pieces
The first step in this project for me was to make a list of all the repos I wanted to consolidate. This included public and private repos, and only repos containing my original work. 

**My list:**
1. homelab - The various iterations of my homelab configuration repos. [Gitea](https://gitea.jafner.tools/Jafner/homelab), [Github (docker_config)](https://github.com/Jafner/docker_config), [Github (wiki)](https://github.com/Jafner/wiki), [Github (cloud_tools)](https://github.com/Jafner/cloud_tools), [Github (self-hosting)](https://github.com/Jafner/self-hosting).
2. Jafner.dev - This blog! [Github](https://github.com/Jafner/Jafner.dev).
3. dotfiles - The two copies of my dotfiles repo. [Gitea](https://gitea.jafner.tools/Jafner/dotfiles), [Github](https://github.com/Jafner/dotfiles).
4. nvgm - An unlaunched TTRPG blog in the vein of [Angry GM](https://theangrygm.com/), or [SlyFlourish](https://slyflourish.com/). [Gitea](https://gitea.jafner.tools/Jafner/nvgm)
5. pamidi - Bash script to control PulseAudio with a MIDI device. [Gitea](https://gitea.jafner.tools/Jafner/pamidi), [Github](https://github.com/Jafner/pamidi)
6. docker-llm-amd - Docker AI stack optimized for my RX 7900XTX. [Gitea](https://gitea.jafner.tools/Jafner/docker-llm-amd)
7. doradash - Programming practice project, meant to calculate DORA metrics from observability and CD platforms. [Gitea](https://gitea.jafner.tools/Jafner/doradash)
8. clip-it-and-ship-it - Programming practice project, meant to provide a Twitch Clips-like video highlighting experience for locally-recorded videos. [Gitea (PyClipIt)](https://gitea.jafner.tools/Jafner/PyClipIt), [Github](https://github.com/Jafner/clip-it-and-ship-it). 
9. razer-bat - Python script to indicate Razer mouse battery level on the wireless dock's RGBs. [Github](https://github.com/Jafner/Razer-BatteryLevelRGB)
10. 5etools-docker - Docker image to make hosting 5eTools a *bit* better. [Github](https://github.com/Jafner/5etools-docker)
11. jafner-homebrew - 5eTools-compatible homebrew files for my original content. [Github](https://github.com/Jafner/jafner-homebrew)

I chose to impose upon myself two constraints for this project:

    1. Preserve git histories.
    2. Don't leak secrets.

Without those constraints, it would be as simple as pulling all the repos, running a quick `mkdir ~/Git/Monorepo && for repo in ~/Git/temp/*; do cd $repo; rm -rf .git; done && cp -rp ~/Git/temp/* ~/Git/Monorepo/ && cd ~/Git/Monorepo && git init` and boom, monorepo. Might have some secrets in the code, but those can get cleaned out before the initial commit. Quick and easy. But alas, such a solution wouldn't make a good blog post.

So, the first part is to **pull the repositories we want to consolidate**. 

1. Configure the paths we want to use for the monorepo, and the temporary directory into which we'll clone the constituent repos. I used the following shell environment variables:
  - `MONOREPO_DIR=""` the path we want the monorepo to exist at. I used `~/Git/Jafner.net`.
  - `TEMP_CLONE_DIR=""` the path into which we want to clone the repos we're going to consolidate. I used `~/Git/monorepo_temp`
  - `REPOSITORIES=()` an array of tuples containing the name and URL of each repo we want to clone.
  - Our `dotfiles` and `pamidi` repositories exist as `Jafner/dotfiles` and `Jafner/pamidi` in *both* GitHub and Gitea, so we need to handle those potential collisions.
  - We're going to run a `git clone` on each of those repos, so we need to make sure we have a valid Personal Access Token or other authentication method for each repo. We only need read permissions for these repos.
2. Install `gitleaks`, `git-filter-repo`, and `bfg-repo-cleaner`. These tools facilitate cleaning secrets out of our repos.
  - [gitleaks/gitleaks](https://github.com/gitleaks/gitleaks?tab=readme-ov-file#installing)
  - [newren/git-filter-repo](https://github.com/newren/git-filter-repo/blob/main/INSTALL.md)
  - [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
3. Clone all of our repos and homologize our default branch.
  - We set all of our repos' default branch to `main`, as some of our later steps get messy if we have multiple branches.
  - I'm not sure how non-main branches are handled beyond this point. All my personal repos are single-branch. 

And at this point we have all our repos together in one place. Next we need to prep each repo to be consolidated. But before that, here's the script for the steps described above in this 

```bash
REPOSITORIES=(
   "Jafner.net ssh://git@gitea.jafner.tools:2225/Jafner/Jafner.net.git"
   "homelab ssh://git@gitea.jafner.tools:2225/Jafner/homelab.git"
   "docker_config git@github.com:Jafner/docker_config.git"
   "wiki git@github.com:Jafner/wiki.git"
   "cloud_tools git@github.com:Jafner/cloud_tools.git"
   "self-hosting git@github.com:Jafner/self-hosting.git"
   "Jafner.dev git@github.com:Jafner/Jafner.dev.git"
   "dotfiles_gitea ssh://git@gitea.jafner.tools:2225/Jafner/dotfiles.git"
   "dotfiles_github git@github.com:Jafner/dotfiles.git"
   "nvgm ssh://git@gitea.jafner.tools:2225/Jafner/nvgm.git"
   "pamidi_gitea ssh://git@gitea.jafner.tools:2225/Jafner/pamidi.git"
   "pamidi_github git@github.com:Jafner/pamidi.git"
   "docker-llm-amd ssh://git@gitea.jafner.tools:2225/Jafner/docker-llm-amd.git"
   "doradash ssh://git@gitea.jafner.tools:2225/Jafner/doradash.git"
   "clip-it-and-ship-it git@github.com:Jafner/clip-it-and-ship-it.git"
   "PyClipIt ssh://git@gitea.jafner.tools:2225/Jafner/PyClipIt.git"
   "razer-bat git@github.com:Jafner/Razer-BatteryLevelRGB.git"
   "5etools-docker git@github.com:Jafner/5etools-docker.git"
   "jafner-homebrew git@github.com:Jafner/jafner-homebrew.git"
)
```

### Scrubbing clean

### Reorganization and pruning

### Rebuilding automations

## The Script
In the interest of ensuring my process was maximally reproducible (so I could wipe and restart every time I made a mistake), I wrote this script.

Steps 1, 2, and 3 are hard-coded with parameters specific to the directories and repos I'm working with. After that, everything *should be* agnostic of directories and repos. 

