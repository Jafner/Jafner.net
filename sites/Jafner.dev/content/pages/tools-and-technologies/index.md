+++
title = 'Tools and Technologies'
description = 'My experience with various tech.'
date = 2024-05-28T17:56:47-07:00
draft = false
ogimage = "tools-and-technologies.logo.png"
slug = "technologies"
+++

Below is an annotated list of tools and technologies I've used, how I've used them, and some of my thoughts about them.

## Infrastructure
### Hardware & OS
- Windows XP and up, on x86. Everyone starts somewhere. The release of Windows 8 kickstarted my interest in alternatives.
- Arch Linux. Gave it a whirl in university. Did not enjoy maintaining it longer than a couple months.
- Debian Linux (10 through 12). Used Debian 10 for my first Linux server. Maintained that server through 2 major version upgrades.
- EdgeOS (1.8). Pre-installed on my Ubiquiti EdgeRouter 10X. Powerful, but dated (even at the time).
- VyOS (1.3+). Provides an infrastructure-as-code approach for a networking appliance: my home router.
- (Free|True)NAS (11.X+). My second home server was a NAS running FreeNAS 11. Today, that Theseusian ship is running TrueNAS Scale.
- NixOS (24.05+). A big part of my 2024 was spent learning and deploying NixOS. It's deployed to my desktop and primary server.
- Aruba OS (7.4). Cute little applicance OS for my Aruba S2500-48P network switch.

### Cloud Platforms
- Google Cloud Platform.
- Amazon Web Services.
- Microsoft Azure.
- Digital Ocean.
- RackNerd.

### Virtualization
- KVM.
- QEMU.
- Hashicorp Vagrant.
- VirtualBox.

### Networking
- SMB.
- NFS.
- iSCSI.
- Ethernet.
- SFP/+.
- TCP/IP.
- PPPoE.
- Simple QoS.
- DHCP. (TODO: Subnetting.)
- NAT.
- (D)DNS.
- HTTP.
- Telnet.

## Service Deployment
### K8s
- GKE.
- EKS.
- K3s.
- Minikube.

### Containerization
- Docker (+ Compose).
- Podman.

### Automation
- Atlassian Bamboo.
- GitHub Actions.
- Gitea Actions.
- GitLab CI.
- ArgoCD.

### Secrets Management
- Delinea.
- Sops (+nix).
- Keycloak.
- Vaultwarden.

## Observability
### Metrics
- Prometheus.
- NewRelic.
- Telegraf.

### Logs
- Promtail.
- Systemd/Journald.
- Splunk.

### Instrumentation
- Prometheus exporters.
- TODO: OpenTelemetry.

### Visualization
- Grafana.
- NewRelic.

### Time-Series Database
- InfluxDB.
- Prometheus.

### Uptime
- Uptime-Kuma.
- Uptime-Robot.

## Services
### SSO (OAuth + OIDC)
- Keycloak.
- Authelia.
- Authentik.
- OneLogin.

### Reverse Proxy
- Traefik.
- Nginx.
- TODO: Caddy.

### Video Delivery
- Plex.
- Jellyfin.
- Cloudflare Stream.
- Zipline.

### AI/LLM Inference
- Ollama.
- OpenRouter.
- SillyTavern.
- OpenWebUI.

### Git
- GitHub.
- GitLab-CE.
- Gitea.

### Automation
- N8n.
- Gitea-runner.

### Game Server
- Terraria.
- Minecraft.

### Productivity Suite
- Nextcloud.
- Coder.

### VPN
- Wireguard.
- TODO: Tailscale (Headscale).

### Website
- WordPress.
- Hugo.
- GitHub Pages.

## Scripting & Programming
### Shell Script
- `clips`. Provides workflows for remuxing, transcoding, and uploading video files clipped from gameplay footage.
- `vyos.sh`. Provides workflows for remotely interacting with the VyOS server, including support for encrypted secrets.
- `razer-bat.sh`. Provides a shell daemon to indicate wireless mouse battery level via arbitrary (Razer) RGB target. Uses `razer-cli`.
- `keyman`. Provided function-oriented workflows for GPG.

### Web Application
- 5etools-docker. A tiny docker image that provides self-updating and homebrew-preserving functionality for self-hosted 5eTools.

### Local Application
- TODO.

## Data Assurance & Reliability
### Safety
- ZFS RAIDZ.
- ZFS Scrub.
- SMART.
- Rsync.
- RAID.

### Security
- In-flight encryption for backups.
- TODO: At-rest encryption for backups.

## Dev Tools
### Terminal Emulator
- Kitty.
- Warp Terminal.
- Konsole.
- GNOME Terminal.
- XTerm.

### Shell
- Bash.
- Zsh.
- Sh.

### Text Editor
- VSCodium.
- Zed.
- Vim.
- Emacs.
- Nano.
- Notepad++.
- Sublime.

### Web Browser
- Zen Browser.
- Firefox.
- Chromium.
- Lynx.
- Ladybird.

### AI Assistant
- Continue.dev VSCode Extension.
- Tab9 VSCode Extension.
- TODO: Cursor, Devin.

## Other
### Media Processing
- ffmpeg/libav. ffmpeg is wizardry and I've learned to cast a few spells.

### Automotive ECU Tuning
- ECUFlash.
- RomRaider.
