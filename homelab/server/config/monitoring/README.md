# Monitoring Specification
Monitors are split into three types: Host, Application, and IoT
All monitors use a Prometheus exporter.

## Hosts
| Name | IP (if static) | OS | Exporter |
|:----:|:--------------:|:--:|:--------:|
| Router | 192.168.1.1 | Linux 4.14) | [node_exporter](https://github.com/prometheus/node_exporter) |
| Server | 192.168.1.23 | Linux 5.10) | [node_exporter](https://github.com/prometheus/node_exporter) |
| Seedbox | 192.168.1.21 | Linux 5.10) | [node_exporter](https://github.com/prometheus/node_exporter) |
| NAS | 192.168.1.10 | FreeBSD 12.2) | ???
| PiHole | 192.168.1.22 | Linux 5.10) | [node_exporter](https://github.com/prometheus/node_exporter) |

## Applications
| Name | Address(es) | Exporter |
|:----:|:-------:|:--------:|
| Minecraft | e6.jafner.net, vanilla.jafner.net | [mc-monitor](https://github.com/itzg/mc-monitor)
| GitLab | gitlab.jafner.net | [GitLab Integrated Exporter](https://docs.gitlab.com/ee/administration/monitoring/prometheus/gitlab_metrics.html)
| Traefik | traefik.jafner.net | [Prometheus - Traefik.io](https://doc.traefik.io/traefik/observability/metrics/prometheus/) |
| Deluge | jafner.seedbox:52000, jafner.seedbox:52100, jafner.seedbox:52200 | [deluge_exporter](https://github.com/tobbez/deluge_exporter) |
| Plex | plex.jafner.net | [Tautulli](https://github.com/Tautulli/Tautulli) and [tautulli-exporter](https://github.com/nwalke/tautulli-exporter), or [plex_exporter](https://github.com/arnarg/plex_exporter) |
| PeerTube | peertube.jafner.net | [Add a Prometheus Exporter - GitHub Issue](https://github.com/Chocobozzz/PeerTube/issues/3742) |
| WordPress | nvgm.jafner.net | [wordpress-exporter](https://github.com/aorfanos/wordpress-exporter) |
| SabNZBD | sabnzbd.jafner.net | [sabnzbd_exporter](https://github.com/msroest/sabnzbd_exporter) |
| Uptime Kuma | uptime.jafner.tools | [Prometheus Integration - Uptime Kuma Wiki](https://github.com/louislam/uptime-kuma/wiki/Prometheus-Integration) |
| PiHole | jafner.pi1 | [pihole-exporter](https://github.com/eko/pihole-exporter) |
| ZFS | nas.jafner.net | [zfs_exporter](https://github.com/pdf/zfs_exporter) |

## IoT
| Name | Hostname | Assigned IP | Note |
|:----:|:--------:|:-----------:|:----:|
| tasmota-1 | tasmota-F6441E-1054 | 192.168.1.50 | 
| tasmota-2 | tasmota-F6D7D3-6099 | 192.168.1.51 |
| tasmota-3 | tasmota-F6F062-4194 | 192.168.1.52 |

# Adding Loki and Promtail
Followed [this guide from Techno Tim](https://docs.technotim.live/posts/grafana-loki/).
Non-tracked changes include:
1. `docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions` to install the Loki docker plugin.
2. Edit `/etc/docker/daemon.json` to add the following block:

```json
{
    "live-restore": true
    "log-driver": "loki",
    "log-opts": {
        "loki-url": "http://localhost:3100/loki/api/v1/push",
        "loki-batch-size": "400"
    }
}
```
3. Refer to the documentation for [restarting the docker daemon](/homelab/docs/Restart the Docker Daemon.md)