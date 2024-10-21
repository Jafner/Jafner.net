terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    dns = {
      source = "hashicorp/dns"
      version = "3.4.1"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

locals {
  secrets = { for tuple in regexall("(.*)=(.*)", file("secrets.env")) : tuple[0] => sensitive(tuple[1]) }
  env = { for tuple in regexall("(.*)=(.*)", file("vars.env")) : tuple[0] => sensitive(tuple[1]) }
}

provider "cloudflare" {
  api_token = local.secrets.CLOUDFLARE_API_KEY
}

provider "digitalocean" {
  token = local.secrets.DIGITALOCEAN_API_KEY
}

