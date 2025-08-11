### Caddy Labels
*via [lucaslorentz/caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy)*

**Basic reverse proxy**
```
labels:
  caddy: myservice.jafner.net
  caddy.reverse_proxy: "{{upstreams 8080}}"
```

**Forwardauth**
```
labels:
  caddy.forward_auth: https://auth.jafner.net:443
  caddy.forward_auth.uri: /_oauth
  caddy.forward_auth.copy_headers: X-Forwarded-User
```

**Restrict access to private IPs**
```
labels:
  caddy: myservice.jafner.net
  caddy.@denied.not.remote_ip: private_ranges
  caddy.abort: "@denied"
  caddy.reverse_proxy: "{{upstreams 80}}"
```
Note: `private_ranges` in Caddy corresponds to: `192.168.0.0/16 172.16.0.0/12 10.0.0.0/8 127.0.0.1/8 fd00::/8 ::1`


**Static web response for non-web services**
```
labels:
  caddy: mynonwebservice.jafner.net
  caddy.respond: / "HTTP not supported. Use nonwebservice on port 11080." 301
```

### UptimeKuma Labels
*via [BigBoot/AutoKuma](https://github.com/BigBoot/AutoKuma)*

**Basic self-monitor**
```
labels:
  kuma.myservice.http.name: 'My Service'
  kuma.myservice.http.url: 'https://myservice.jafner.net'
```

**Status notifications**
*Note: Requires `mynotificationprovider` to exist in UptimeKuma configuration.*
```
labels:
  kuma.myservice.http.notification_names: '["mynotificationprovider"]'
```

### Homepage Labels
*via [gethomepage/homepage](https://gethomepage.dev/configs/docker/#automatic-service-discovery)*
*Get icons from [selfh.st/icons](https://selfh.st/icons/)*

**Basic Homepage listing**
```
labels:
  homepage.name: My Service
  homepage.icon: sh-my-service
  homepage.href: https://myservice.jafner.net
  homepage.description: A simple service.
```

### Minecraft Server Labels
*via [itzg/mc-router](https://github.com/itzg/mc-router?tab=readme-ov-file#using-docker-auto-discovery)*

**Reverse proxy**
```
labels:
  mc-router.host: mymcserver.jafner.net
  mc-router.port: "25565"
  mc-router.network: minecraft
  mc-router.default: true
```

**Caddy redirect web traffic to mcstatus.io dashboard**
```
labels:
  caddy: mymcserver.jafner.net
  caddy.redir: https://mcstatus.io/status/java/mymcserver.jafner.net
```
