These configurations must be applied in the following order:

1. CustomResourceDefinition.yaml
2. ClusterRole.yaml
3. ClusterRoleBinding.yaml
4. Service.yaml
5. ServiceAccount.yaml
6. Deployment.yaml
7. IngressRoute.yaml
8. TLSOption.yaml

```
kubectl apply -f CustomResourceDefinition.yaml && \
kubectl apply -f ClusterRole.yaml && \
kubectl apply -f ClusterRoleBinding.yaml && \
kubectl apply -f ServiceAccount.yaml && \
kubectl apply -f Service.yaml && \
kubectl apply -f Deployment.yaml && \
kubectl apply -f IngressRoute.yaml && \
kubectl apply -f TLSOption.yaml
```