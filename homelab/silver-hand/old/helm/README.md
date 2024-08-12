# Helm
This directory contains documentation and files related to configuring Helm for the Silver Hand cluster. 

### Repositories Used
- [kubernetes-dashboard](https://kubernetes.github.io/dashboard/) to provide [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/).

### Steps Taken So Far
```
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
```

```
helm repo add traefik https://traefik.github.io/charts
helm install traefik traefik/traefik --version 30.0.2
```

```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.2/cert-manager.crds.yaml
helm repo add jetstack https://charts.jetstack.io --force-update
helm install cert-manager --namespace cert-manager --version v1.15.2 jetstack/cert-manager

```

#### Sources:
[Deploy and Access the Kubernetes Dashboard - Kubernetes.io](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)