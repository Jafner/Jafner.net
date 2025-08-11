# https://rclone.org/docker/

**Install**
`docker plugin install rclone/docker-volume-rclone:amd64 args="-v --allow-other --no-check-certificate" --alias rclone --grant-all-permissions`

**Fix after docker daemon crash**

```sh
sudo systemctl restart docker.service
sudo rm /var/lib/docker-plugins/rclone/cache/docker-plugin.state

docker start $(docker ps -aq)
```

**Create shared volumes**

```sh
docker volume create movies \
  -d rclone \
  -o remote=paladin:Movies \
  -o allow-other=true \
  -o vfs-cache-mode=full \
  -o poll_interval=0 && \
docker volume create shows \
  -d rclone \
  -o remote=paladin:Shows \
  -o allow-other=true \
  -o vfs-cache-mode=full \
  -o poll_interval=0 && \
docker volume create music \
  -d rclone \
  -o remote=paladin:Music \
  -o allow-other=true \
  -o vfs-cache-mode=full \
  -o poll_interval=0 && \
docker volume create stash \
  -d rclone \
  -o remote=paladin:Stash \
  -o allow-other=true \
  -o vfs-cache-mode=full \
  -o poll_interval=0 && \
docker volume create torrenting \
  -d rclone \
  -o remote=paladin:Torrenting \
  -o allow-other=true \
  -o vfs-cache-mode=full \
  -o poll_interval=0
```

```yml
volumes:
  movies:
    name: movies
    driver: rclone
    driver_opts:
      remote: paladin:Movies
      allow_other: "true"
      vfs_cache_mode: full
      poll_interval: 0
  shows:
    name: shows
    driver: rclone
    driver_opts:
      remote: paladin:Shows
      allow_other: "true"
      vfs_cache_mode: full
      poll_interval: 0
  music:
    name: music
    driver: rclone
    driver_opts:
      remote: paladin:Music
      allow_other: "true"
      vfs_cache_mode: full
      poll_interval: 0
```

`docker plugin inspect rclone`

```json
[
  {
    "Config": {
      "Args": {
        "Description": "",
        "Name": "args",
        "Settable": ["value"],
        "Value": []
      },
      "Description": "Rclone volume plugin for Docker",
      "DockerVersion": "28.0.4",
      "Documentation": "https://rclone.org/docker",
      "Entrypoint": ["rclone", "serve", "docker"],
      "Env": [
        {
          "Description": "",
          "Name": "RCLONE_VERBOSE",
          "Settable": ["value"],
          "Value": "0"
        },
        {
          "Description": "",
          "Name": "RCLONE_CONFIG",
          "Settable": null,
          "Value": "/data/config/rclone.conf"
        },
        {
          "Description": "",
          "Name": "RCLONE_CACHE_DIR",
          "Settable": null,
          "Value": "/data/cache"
        },
        {
          "Description": "",
          "Name": "RCLONE_BASE_DIR",
          "Settable": null,
          "Value": "/mnt"
        },
        {
          "Description": "",
          "Name": "HTTP_PROXY",
          "Settable": ["value"],
          "Value": ""
        },
        {
          "Description": "",
          "Name": "HTTPS_PROXY",
          "Settable": ["value"],
          "Value": ""
        },
        {
          "Description": "",
          "Name": "NO_PROXY",
          "Settable": ["value"],
          "Value": ""
        }
      ],
      "Interface": {
        "Socket": "rclone.sock",
        "Types": ["docker.volumedriver/1.0"]
      },
      "IpcHost": false,
      "Linux": {
        "AllowAllDevices": false,
        "Capabilities": ["CAP_SYS_ADMIN"],
        "Devices": [
          {
            "Description": "",
            "Name": "",
            "Path": "/dev/fuse",
            "Settable": null
          }
        ]
      },
      "Mounts": [
        {
          "Description": "",
          "Destination": "/data/config",
          "Name": "config",
          "Options": ["rbind"],
          "Settable": ["source"],
          "Source": "/home/admin/.config/rclone/",
          "Type": "bind"
        },
        {
          "Description": "",
          "Destination": "/data/cache",
          "Name": "cache",
          "Options": ["rbind"],
          "Settable": ["source"],
          "Source": "/var/lib/docker-plugins/rclone/cache",
          "Type": "bind"
        }
      ],
      "Network": {
        "Type": "host"
      },
      "PidHost": false,
      "PropagatedMount": "/mnt",
      "User": {},
      "WorkDir": "/data",
      "rootfs": {
        "diff_ids": [
          "sha256:c360c17c2d8f636ee4a756cd7fbe7ba2bc2b0b1e007e235391ce9525f73524b6"
        ],
        "type": "layers"
      }
    },
    "Enabled": true,
    "Id": "eaee6ec9b35afe9a4d2a355ba72d7feb9383696e28bbb92c1ff0a49d68b6c7f0",
    "Name": "rclone:latest",
    "PluginReference": "docker.io/rclone/docker-volume-rclone:amd64",
    "Settings": {
      "Args": ["-v", "--allow-other", "--no-check-certificate"],
      "Devices": [
        {
          "Description": "",
          "Name": "",
          "Path": "/dev/fuse",
          "Settable": null
        }
      ],
      "Env": [
        "RCLONE_VERBOSE=0",
        "RCLONE_CONFIG=/data/config/rclone.conf",
        "RCLONE_CACHE_DIR=/data/cache",
        "RCLONE_BASE_DIR=/mnt",
        "HTTP_PROXY=",
        "HTTPS_PROXY=",
        "NO_PROXY="
      ],
      "Mounts": [
        {
          "Description": "",
          "Destination": "/data/config",
          "Name": "config",
          "Options": ["rbind"],
          "Settable": ["source"],
          "Source": "/home/admin/.config/rclone/",
          "Type": "bind"
        },
        {
          "Description": "",
          "Destination": "/data/cache",
          "Name": "cache",
          "Options": ["rbind"],
          "Settable": ["source"],
          "Source": "/var/lib/docker-plugins/rclone/cache",
          "Type": "bind"
        }
      ]
    }
  }
]
```

`docker volume inspect movies`

```json
[
  {
    "CreatedAt": "2025-06-06T05:07:31Z",
    "Driver": "rclone:latest",
    "Labels": {
      "com.docker.compose.config-hash": "069c724f75e9a078ee67706f4fcee1481538a420d8373622cce68975dfc2a338",
      "com.docker.compose.project": "plex",
      "com.docker.compose.version": "2.35.1",
      "com.docker.compose.volume": "movies"
    },
    "Mountpoint": "/mnt/movies",
    "Name": "movies",
    "Options": {
      "allow_other": "true",
      "poll_interval": "0",
      "remote": "paladin:Movies",
      "vfs_cache_mode": "full"
    },
    "Scope": "local",
    "Status": {
      "Mounts": [
        "8e074f946e875beb4b69e87850dc54d6f5e885d601cff26467f2d05f6e8a754e"
      ]
    }
  }
]
```

**Configure volume in compose**
_Top-level `volumes:` directive._

```yml
volumes:
  movies:
    name: movies
    driver: rclone
    driver_opts:
      remote: "paladin:Movies"
      allow_other: "true"
      vfs_cache_mode: full
      poll_interval: 0
```

_Don't forget to add the volume to the container._
