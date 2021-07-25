---
title: Grafana Setup Information
description: 
published: true
date: 2021-07-25T21:59:55.861Z
tags: 
editor: markdown
dateCreated: 2021-07-19T20:35:25.196Z
---

# Purpose and Layout
My Grafana dashboard serves as a one-stop systems monitoring frontend. 

![grafana.png](/grafana.png =50%x)


# Grafana

# InfluxDB

| Host | Database Name | Inputs |
|:-|-:|:-|
| Main Server | `jafgraf` |
| Seedbox | `seedbox` |
| NAS | `nas` |
| PiHole | `pihole` | 

The full configuration files for the main server are available at: [Jafner/docker_compose/grafana-stack](https://github.com/Jafner/docker_config/tree/master/grafana-stack).

# Telegraf
Below are excerpts from the `telegraf.conf` and accompanying files for each host. All config files are based on the [config files](https://github.com/Mbarmem/Grafana.Dashboard/blob/master/docker/telegraf/telegraf.conf) from Mbarmem's repository.

## Main Server
```toml
[global_tags]
[agent]
  interval = "10s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  precision = ""
  hostname = ""
  omit_hostname = false
[[outputs.influxdb]]
  urls = ["http://influxdb:8086"]
  database = "jafgraf"
[[inputs.cpu]]
  percpu = true
  totalcpu = true
  collect_cpu_time = false
  report_active = false
[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]
[[inputs.mem]]
[[inputs.system]]
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
[[inputs.sensors]]
[[inputs.file]]
  files = ["/.forgetps.json"]
  data_format = "json"
  name_override = "tickinfo"
  tag_keys = ["dim"] 
```

### Getting Forge Server Tick Info
The main server's Telegraf instance gets information about my Forge server using a chain of tools. `cron` runs `docker exec e6 rcon-cli forge
```bash
#!/bin/bash
# this script converts the output of the "forge tps" command (in the form of the .forgetps file) into json for sending to influxdb
# by default it reads from stdin and outputs to a .forgetps.json file
while IFS= read -r line; do
  if [ "$line" != "" ]; then
    DIM=$(echo -n "$line" | awk '{print $2}')
    if [ "$DIM" = "Mean" ]; then
      DIM="Overall"
    fi
    TPT=$(echo "$line" | grep -oE 'Mean tick time: .+ms' | awk '{print $4}')
    TPS=$(echo "$line" | grep -oE 'Mean TPS: .+' | awk '{print $3}')
    JSON+=\{$(echo \"dim\":\"$DIM\",\"tpt\":$TPT,\"tps\":$TPS)\}, 
  fi
#done < .forgetps # inputs from .forgetps file
done <$1 # inputs from file passed via stdin
JSON=$(echo ${JSON} | sed 's/,$//')

#echo [${JSON}] >&1 # outputs to stdout
echo [${JSON}] > .forgetps.json # uncomment this to output to file
```

```
* * * * * cd /home/joey/docker_config/grafana-stack/scripts/ && docker exec e6 rcon-cli forge tps > .forgetps && ./forgetps-to-json.sh .forgetps
```

## NAS
```toml
[global_tags]
  role = "freenas"
[[outputs.influxdb]]
  urls = ["http://192.168.1.23:8086"]
  database = "nas"
[[inputs.cpu]]
  percpu = true
  totalcpu = true
[[inputs.mem]]
[[inputs.net]]
[[inputs.system]]
[[inputs.diskio]]
[[inputs.zfs]]
  poolMetrics = true
[[inputs.exec]]
  name_override = "diskhealth"
  commands = ["/root/telegraf/diskstatus.sh"]
  timeout = "30s"
  data_format = "json"
  tag_keys = ["disk","health"]
[[inputs.exec]]
  name_override = "cputemps"
  commands = ["sh /root/telegraf/cputemp.sh"]
  timeout = "5s"
  data_format = "influx"
```

## Seedbox
```toml
[global_tags]
[agent]
  interval = "10s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  precision = ""
  hostname = ""
  omit_hostname = false
[[outputs.influxdb]]
  urls = ["http://192.168.1.23:8086"]
  database = "seedbox"
[[inputs.cpu]]
  percpu = true
  totalcpu = true
  collect_cpu_time = false
  report_active = false
[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]
[[inputs.mem]]
[[inputs.system]]
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
[[inputs.sensors]]
```
## PiHole
```toml
[global_tags]
[agent]
  interval = "10s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  precision = ""
  hostname = ""
  omit_hostname = false
[[outputs.influxdb]]
  urls = ["http://192.168.1.23:8086"]
  database = "pihole"
[[inputs.http]]
  urls = ["http://192.168.1.191/admin/api.php"]
  method = "GET"
  data_format = "json"
  json_string_fields = ["status"]
  name_suffix = "_pihole" 
```
# Resources
The main guide I used for my setup: https://github.com/Mbarmem/Grafana.Dashboard
The guide I used for installing Telegraf on my NAS: https://blog.victormendonca.com/2020/10/28/how-to-install-telegraf-on-freenas/
The repository containing my 
The instructions I followed to get SMART HDD reporting from the NAS: https://www.reddit.com/r/freenas/comments/81t2bw/can_i_install_telegraf_on_my_freenas_host/dv67xu8/