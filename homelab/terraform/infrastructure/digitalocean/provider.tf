terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "~> 2.0"
        }
    }
}

provider "digitalocean" {
  token = var.digitalocean_token
}

variable "digitalocean_token" {
  type = string
  default = "var.digitalocean_token"
}

variable "private_key" {
    type = string
    default = "C:/Users/jafne/.ssh/main_id_rsa"
}
