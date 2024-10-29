# Homelab
This directory contains the files that compose my homelab.

## Map of Contents

| Project             | Summary | Path |
|:-------------------:|:-------:|:----:|
| barbarian           | Documentation and scripts for the `barbarian` TrueNAS host | [`barbarian`](/homelab/barbarian/) |
| docs                | Standalone documentation for architecture and procedure | [`docs`](/homelab/docs/) |
| druid | Docker compose files and documentation for the `druid` cloud compute host | [`druid`](/homelab/druid/) |
| fighter | Docker compose configuration, documentation, and scripts related to the `fighter` local compute host | [`fighter`](/homelab/fighter/) | 
| monk | Documentation for the `monk` TrueNAS host | [`monk`](/homelab/monk/) |
| paladin | Documentation for the `paladin` TrueNAS host | [`paladin`](/homelab/paladin/) |
| sellswords | Documentation and Terraform configuration files for cloud vendors such as AWS and Cloudflare | [`sellswords`](/homelab/sellswords/) |
| silver-hand | Documentation and Terraform configuration for the `silver-hand` local Kubernetes cluster | [`silver-hand`](/homelab/silver-hand/) |
| stacks | Maximally independent Docker compose files for various services  | [`stacks`](/homelab/stacks/)  |
| wizard | Documentation, configuration, and scripts for the `wizard` VyOS host | [`wizard`](/homelab/wizard/)  |

## Configure a New Host

### NixOS

- Download the [NixOS ISO installer](https://nixos.org/download/#nixos-iso). 
- Refer to the [NixOS Manual](https://nixos.org/manual/nixos/stable/) for further instructions. 

## Security
Below are described the general security principles followed throughout this project:

- Never lean on security through obscurity.
- Minimize friction induced by security. Friction induces laziness, which inevitably circumvents the original security system.
- Understand that security practices cannot *eliminate* vulnerability of the system, only make it *too expensive* to attack.
- Tie less important secrets to more important secrets, but not vice-versa. 

Further, we have some tool-specific guidelines.

### Securing SSH
When configuring the SSH server for a local host or VPS, or when provisioning a new SSH keypair. 
- Generate one private key for each user-machine pair. 
- Do not automate dissemination of pubkeys. Always install pubkeys manually.
- Disable password-based authentication. 
- Disable root login. 

### Docker Compose
To write secrets into `docker-compose.yml` files securely, we use the following [`env_file`](https://docs.docker.com/reference/compose-file/services/#env_file) snippet:

```yaml
env_file:
  - path: ./<service>.secrets
    required: true
```

And we then write the required secrets in [dotenv format](https://www.dotenv.org/docs/security/env.html) in a file located at `./<service>.secrets`. For example:

```dotenv
API_KEY=zj1vtmUNGIfHJBfYsDINr8AVN5on1Hy0
# ROOT_PASSWORD=changeme
ROOT_PASSWORD=0gavJVrsv89bmdDeJXAcI1eCvQ4Um8Hy
```

When these files are staged in git, our [.gitattributes](/.gitattributes) runs the `sops` filter against any file matching one of its described patterns. 

### Web Services
**If a service supports OAuth2**, we configure [Keycloak SSO]() for that service. 
When feasible, we shift responsibility for authentication and authorization to Keycloak. This is dependent on each service implementing OAuth2/OpenIDConnect. 

**If a service does not support OAuth2**, but it does support authentication via the `X-Forwarded-User` header, we use [mesosphere/traefik-forward-auth](https://github.com/mesosphere/traefik-forward-auth) as a Traefik middleware. This middleare restricts access to the service regardless of whether the service understands the `X-Forwarded-User` header, which makes it useful for compatible multi-user applications *and* single-user applications. 

**If a service should not be internet-accessible**, we use Traefik's [`ipWhiteList`](https://doc.traefik.io/traefik/middlewares/http/ipwhitelist/) middleware to restrict access to LAN IPs only. 

**Else**, some services *absolutely require* separate authentication (e.g. Plex, N8n). In such cases, we create user credentials as we would for any internet service; using our password manager.
