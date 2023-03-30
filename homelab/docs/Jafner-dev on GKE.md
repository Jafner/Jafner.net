# Exercise: jafner.dev on GKE
[Cert-Manager - Deploy cert-manager on Google Kubernetes Engine](https://cert-manager.io/docs/tutorials/getting-started-with-cert-manager-on-google-kubernetes-engine-using-lets-encrypt-for-ingress-ssl/)

## Setting Up Initial Services
1. Create cluster `gcloud container clusters create jafner-dev --preemptible --num-nodes=3`
   This cluster is preemptible, which means it's basically for testing and will kill itself within 24 hours. This command will take a few minutes to create the cluster.
2. Create the example hello and hello2 deployments: `kubectl apply -f ./hello/Deployment.yaml -f ./hello2/Deployment.yaml`
3. Create the example hello and hello2 internal services: `kubectl apply -f ./hello/Service.yaml -f ./hello2/Service.yaml`
4. Create a public global static IP for the cluster to use: `gcloud compute addresses create web-ip --global`
   This step is applied across the GCP project and is not necessary for a new cluster. 
5. Open [Google Domains for jafner.dev](https://domains.google.com/registrar/jafner.dev/dns?hl=en) and ensure the A records for `*.jafner.dev` and `jafner.dev` are pointed at the correct IP address.
6. Create the Ingress without TLS: `kubectl apply -f ./Ingress-noTLS.yaml`
   Once this ingress is created, the services should be internet accessible by domain name. Try `curl http://hello.jafner.dev` and `curl http://hello2.jafner.dev`. 
7. Install cert-manager: `kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.2/cert-manager.yaml` (We use the generic merged manifest here).
   After this is done, you can use `kubectl explain` for the new CustomResourceDefinitions `Certificate`, `CertificateRequest`, and `Issuer`, which are installed with Cert-manager.
8. Create staging and production Issuers for LetsEncrypt: `kubectl apply -f ./cert-manager/Issuer.yaml`
9. Create empty secret for storing SSL certificate: `kubectl apply -f ./cert-manager/Secret.yaml`
10. Apply the Ingress with TLS configured with the staging issuer: `kubectl apply -f Ingress-staging.yaml`
    It will take several minutes for the background process of acquiring and loading the certificate to complete. You can check on the process with `curl -v --insecure https://hello.jafner.dev`. While the process is running, you will get an error code 35 with `SSL_ERROR_SYSCALL`. Once the process is complete, curl will return verbose certificate information and the "Hello, world!" message from the server. 
11. Apply the Ingress with TLS configured with the production issuer: `kubectl apply -f Ingress.yaml`
    This process will take several minutes like the previous one. Once it is complete, you should be able to access `https://hello.jafner.dev` and `https://hello2.jafner.dev` by browser.

## Adding A New Service: `dndtools`
1. Deploy the new service: `kubectl apply -f ./dndtools/Deployment.yaml -f ./dndtools/Service.yaml`
2. Edit `Ingress.yaml` to configure the new application.
	1. Add the new host to `spec.tls.hosts` (e.g. 5e.jafner.dev).
	2. Add a stanza to `spec.rules` for the new host. For example:
```
spec:
  rules:
  - host: "5e.jafner.dev"
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: dndtools
            port:
              number: 80
```
3. Apply the edited `Ingress.yaml`: `kubectl apply -f Ingress.yaml` and wait for the changes to apply. Once changes are applied, the new service will be accessible in the browser at `https://5e.jafner.dev`.

Done!