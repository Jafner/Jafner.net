# Provision the host as a Digital Ocean droplet, configure SSH access, run docker install script
resource "digitalocean_droplet" "birch" {
  image  = "debian-12-x64"
  name   = "birch"
  region = "sfo3"
  size   = "s-1vcpu-1gb"
  ssh_keys = ["04:b4:49:d8:bc:68:73:dd:45:fd:56:1f:d3:ea:37:7a"]
  connection {
    host = self.ipv4_address
    type = "ssh"
    user = "root"
    private_key = file(var.private_key)
    timeout = "2m"
  }
  provisioner "file" {
    source = "digitalocean/setup.sh"
    destination = "/root/setup.sh"
  }
  provisioner "remote-exec" { 
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh ./get-docker.sh"
    ]
  }
}

output "birch-address" {
    value = digitalocean_droplet.birch.ipv4_address
}
