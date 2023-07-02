terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "3.0.2"
        }
        cloudflare = {
            source = "cloudflare/cloudflare"
            version = "~> 4.0"
        }
    }
}

data "terraform_remote_state" "infrastructure" {
    backend = "local"
    config = {
        path = "../infrastructure/terraform.tfstate"
    }
}

provider "docker" {
    host = "ssh://root@${data.terraform_remote_state.infrastructure.outputs.birch-address}:22"
    ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

provider "cloudflare" {
    api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {
}