
resource "cloudflare_record" "uptime-jafner-tools" {
  zone_id = "b30ea6e5a3d8f7e9a0f64f95332635a7"
  name = "uptime"
  value = "${data.terraform_remote_state.imnotsurewhatthisis.outputs.synthetic-monitor-address}"
  type = "A"
}



# Define the application container
resource "docker_container" "uptime_kuma" {
  image = "louislam/uptime-kuma:latest"
  name = "uptime-kuma"
  restart = "always"
  volumes {
    container_path = "/app/data"
    volume_name = "uptime_kuma"
  }
  networks_advanced {
    name = "web"
  }
  labels {
    label = "traefik.http.routers.uptime-kuma.rule"
    value = "Host(`uptime.jafner.tools`)"
  }
  labels {
    label = "traefik.http.routers.uptime-kuma.tls.certresolver"
    value = "lets-encrypt"
  }
}

resource "docker_volume" "uptime_kuma" {
  name = "uptime_kuma"
}