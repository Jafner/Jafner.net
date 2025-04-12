### The `web` Network

Created with `docker network create --driver=bridge --subnet=172.20.0.0/23 --ip-range=172.20.1.0/24 web`

Previous version was naive, and had a subnet equal in size to the IP range. This meant that we would occasionally encounter address colisions between services which needed static IPs, and those handed IPs automatically.

### Useful Labels

Basic web-facing service:
- ```traefik.http.routers.<router-name>.rule=Host(`<subdomain>.jafner.net`)```
- `traefik.http.routers.<router-name>.tls.certresolver=lets-encrypt`

Restrict access to IPs to those defined by the `lan-only` middleware:
- `traefik.http.routers.<router-name>.middlewares=lan-only@file`

Explicitly set the container-side port Traefik should route traffic to:
- `traefik.http.services.<service-name>.loadbalancer.server.port=1234`
