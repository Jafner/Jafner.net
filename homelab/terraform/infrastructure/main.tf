module "digitalocean" {
    source = "./digitalocean"
    digitalocean_token = var.digitalocean_token
}

variable "digitalocean_token" {
}

/*
module "google" {
    source = "./google"
}
*/

output "birch_ip_address" {
    value = module.digitalocean.birch-address
}