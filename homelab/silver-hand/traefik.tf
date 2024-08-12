resource "kubernetes_namespace" "traefik" {
    metadata {
        name = "traefik"
    }
}

resource "helm_release" "traefik" {
    depends_on = [
        kubernetes_namespace.traefik
    ]
    name = "traefik"
    namespace = "traefik"
    repository = "https://traefik.github.io/charts"
    chart = "traefik"
    version = "30.0.2"
    lint = true
    cleanup_on_fail = true
    create_namespace = true
    dependency_update = true
    replace = true
    set {
        name  = "ingressClass.enabled"
        value = "true"
    }
    set {
        name  = "ingressClass.isDefaultClass"
        value = "true"
    }
    set {
        name  = "ports.web.redirectTo.port"
        value = "websecure"
    }
    set {
        name  = "ports.websecure.tls.enabled"
        value = "true"
    }

    # In my local k3s environment, we need to give the Traefik service at least one external IP
    # Else it will be stuck <pending> and terraform will fail to apply.
    set_list { 
        name = "service.externalIPs"
        value = [
            "192.168.1.31",
            "192.168.1.32",
            "192.168.1.33"
        ]
    }
}

