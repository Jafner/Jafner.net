resource "kubernetes_namespace" "nginx1" {
    metadata {
        name = "nginx1"
    }
}

resource "kubernetes_deployment" "nginx1" {
    depends_on = [
        kubernetes_namespace.nginx1
    ]
    metadata {
        name = "nginx1"
        namespace = "nginx1"
        labels = {
            app = "nginx1"
        }
    }
    spec {
        replicas = 1
        selector {
            match_labels = {
                app = "nginx1"
            }
        }
        template {
            metadata {
                labels = {
                    app = "nginx1"
                }
            }
            spec {
                container {
                    image = "nginx:latest"
                    name  = "nginx"

                    port {
                        container_port = 80
                    }
                }
            }
        }
    }
}


resource "kubernetes_service" "nginx1" {
    depends_on = [
        kubernetes_namespace.nginx1
    ]
    metadata {
        name = "nginx1"
        namespace = "nginx1"
    }
    spec {
        selector = {
            app = "nginx1"
        }
        port {
            port = 80
        }
        type = "ClusterIP"
    }
}

resource "kubectl_manifest" "nginx1-certificate" {
    depends_on = [kubernetes_namespace.nginx1, time_sleep.wait_for_clusterissuer]
    yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nginx1
  namespace: nginx1
spec:
  secretName: nginx1
  issuerRef:
    name: cloudflare-prod
    kind: ClusterIssuer
  dnsNames:
  - 'nginx1.jafner.dev'   
    YAML
}

resource "kubernetes_ingress_v1" "nginx1" {
    depends_on = [kubernetes_namespace.nginx1]
    metadata {
        name = "nginx1"
        namespace = "nginx1"
    }
    spec {
        rule {
            host = "nginx1.jafner.dev"
            http {
                path {
                    path = "/"
                    backend {
                        service {
                            name = "nginx1"
                            port {
                                number = 80
                            }
                        }
                    }

                }
            }
        }
        tls {
          secret_name = "nginx1"
          hosts = ["nginx1.jafner.dev"]
        }
    }
}

resource "cloudflare_record" "nginx1-k3s-jafner-dev" {
    zone_id = "b6f3735cd87078e4c5d4a17c95cd979f"
    name = "nginx1.jafner.dev"
    content =  data.dns_a_record_set.jafner-net.addrs[0] # Not a typo. We assume jafner.net is pointing at the homelab, and jafner.dev is pointed elsewhere
    type = "A"
    proxied = false
}