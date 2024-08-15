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
  }
}

locals {
  envs = { for tuple in regexall("(.*)=(.*)", file("secrets.env")) : tuple[0] => sensitive(tuple[1]) }
}

provider "cloudflare" {
  api_token = local.envs.CLOUDFLARE_API_TOKEN
}

# Below allows us to reference public IP of TF execution environment 
# with `data.http.myip.body`
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

# Below allows us to reference DNS A-records for the listed domains 
# with `data.dns_a_record_set.<data-object-name>.addrs`
data "dns_a_record_set" "jafner_net" {
  host = "jafner.net"
}
data "dns_a_record_set" "jafner_dev" {
  host = "jafner.dev"
}
data "dns_a_record_set" "jafner_chat" {
  host = "jafner.chat"
}
data "dns_a_record_set" "jafner_tools" {
    host = "jafner.tools"
}

# Zone IDs
data "cloudflare_zone" "jafner_net" {
  name = "jafner.net"
}

data "cloudflare_zone" "jafner_dev" {
  name = "jafner.dev"
}

data "cloudflare_zone" "jafner_tools" {
  name = "jafner.tools"
}

data "cloudflare_zone" "jafner_chat" {
  name = "jafner.chat"
}

