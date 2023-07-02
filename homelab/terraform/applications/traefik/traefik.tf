## NOTE: Before applying, make sure to `touch /root/traefik/acme.json`
# Define the reverse proxy container
resource "docker_container" "traefik" {
  image = "traefik:latest"
  name = "traefik"
  restart = "always"
  ports {
    internal = 443
    external = 443
    protocol = "tcp"
  }
  ports {
    internal = 80
    external = 80
    protocol = "tcp"
  }
  volumes {
    container_path = "/var/run/docker.sock"
    host_path = "/var/run/docker.sock"
    read_only = true
  }
  volumes {
    container_path = "/acme.json"
    host_path = "/root/traefik/acme.json"
  }
  upload {
    source = "traefik.yaml" # source path with filename
    file = "/traefik.yaml" # destination path with filename
  }
  networks_advanced {
    name = "web"
  }
  connection {
    host = ${data.terraform_remote_state.infrastructure.outputs.birch-address}
    type = "ssh"
    user = "root"
    private_key = file(var.private_key)
    timeout = "2m"
  }
  provisioner "remote-exec" { # Using a provisioner is not best practice. See: https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax#provisioners-are-a-last-resort
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh ./get-docker.sh"
    ]
  }
}

resource "docker_network" "web" {
  name = "web"
}