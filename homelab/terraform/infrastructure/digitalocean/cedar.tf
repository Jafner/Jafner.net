# Provision the host as a Digital Ocean droplet, configure SSH access, run docker install script

/*
resource "digitalocean_droplet" "cedar" {
  image  = "debian-12-x64"
  name   = "cedar"
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
  provisioner "remote-exec" { # Using a provisioner is not best practice. See: https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax#provisioners-are-a-last-resort
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh ./get-docker.sh"
    ]
  }
}

output "cedar-address" {
    value = digitalocean_droplet.cedar.ipv4_address
}
*/