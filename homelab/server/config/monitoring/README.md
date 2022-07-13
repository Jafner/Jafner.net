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

## Instrumenting: Daemon-Level Logging
Edit `/etc/docker/daemon.json` to add the following block:

```json
{
    "log-driver": "loki",
    "log-opts": {
        "loki-url": "http://localhost:3100/loki/api/v1/push",
        "loki-batch-size": "400",
        "loki-retries": "1",
        "loki-timeout": "2s"
    }
}
```
NOTE: All logging will fail if the Loki container is inaccessible. This may cause the Docker daemon to lock up. These parameters are applied when a container is created, so all containers must be destroyed to resolve the issue.
NOTE: The batch size here is in lines for *all docker logs*.

## Instrumenting: Per-Container Logging 
Add the following logging parameter to each main-service container within a stack. 
```yml
services:
  <some-service>:
    logging:
      driver: loki
      options:
        loki-url: "http://localhost:3100/loki/api/v1/push"
        loki-batch-size: "50"
        loki-retries: 1
        loki-timeout: 2s
```
NOTE: The batch size here is in lines for *only the selected container*. 

See [loki log-opts](https://grafana.com/docs/loki/latest/clients/docker-driver/configuration/#supported-log-opt-options) for list of available configuration options for loki logging driver.
See [docker-compose logging](https://docs.docker.com/compose/compose-file/compose-file-v3/#logging) for Docker-compose logging reference.

## Instrumenting: Default Docker Logging
Per: [Docker docs](https://docs.docker.com/config/containers/logging/configure/)
> The default logging driver is `json-file`.

The configuration options for the `json-file` logging driver are [here](https://docs.docker.com/config/containers/logging/json-file/).

Docker-compose adds a few labels to containers it starts. This feature is not comprehensively documented, but here: [Compose Specification](https://docs.docker.com/compose/compose-file/). And we can see what labels are added by default by simply looking at a deployed application (wg-easy):

| Label Key | Value |
|:---------:|:-----:|
| `com.docker.compose.config-hash` | `f75588baa1056ddc618b1741805d2600b4380e13c5114106de6c8322f79dfd3f` |
| `com.docker.compose.container-number` | `1` |
| `com.docker.compose.oneoff` | `False` |
| `com.docker.compose.project` | `wireguard` |
| `com.docker.compose.project.config_files` | `docker-compose.yml` |
| `com.docker.compose.project.working_dir` | `/home/joey/homelab/server/config/wireguard` |
| `com.docker.compose.service` | `wg-easy` |
| `com.docker.compose.version` | `1.29.2` |

These are *labels* on the container, which are distinct from *tags* in the actual json log payload. 