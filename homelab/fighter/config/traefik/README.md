### The `web` Network

Created with `docker network create --driver=bridge --subnet=172.20.0.0/23 --ip-range=172.20.1.0/24 web`

Previous version was naive, and had a subnet equal in size to the IP range. This meant that we would occasionally encounter address colisions between services which needed static IPs, and those handed IPs automatically. 