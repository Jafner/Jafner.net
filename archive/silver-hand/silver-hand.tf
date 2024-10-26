terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.31.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.14.1"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
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

provider "kubernetes" {
    config_path = "~/.kube/config"
    config_context = "default"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" { 
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

variable "cloudflare_token" {
  type = string
}

# Below allows us to reference public IP of TF execution environment 
# with `data.http.myip.body`
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

# Below allows us to reference DNS A-records for the listed domains 
# with `data.dns_a_record_set.<data-object-name>.addrs`
data "dns_a_record_set" "jafner-net" {
  host = "jafner.net"
}
data "dns_a_record_set" "jafner-dev" {
  host = "jafner.dev"
}
data "dns_a_record_set" "jafner-chat" {
  host = "jafner.chat"
}

## Look into how to implement a wait-for timer like this for self-hosted k3s.
#resource "time_sleep" "wait_for_kubernetes" {
#    depends_on = [
#        civo_kubernetes_cluster.k8s_demo_1
#    ]
#    create_duration = "20s"
#}