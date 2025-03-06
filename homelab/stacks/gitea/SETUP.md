- Add DNS record for `git.jafner.net` to point to the host.
- Deploy the configuration to the host.
- Bring up the service with `docker compose up -d`.
- Access the config bootstrap interface and configure as follows:

| Field | Value |
|:----:|:----:|
| Database Type | PostgreSQL |
| Host | `postgres:3306` |
| Username | `gitea` |
| Password | As configured in `postgres.secrets` |
| Database Name | `gitea` |
| SSL | Disable |
| Schema | Blank (defaults to "public") |
| Site Title | `Jafner.net Git Server` |
| Repository Root Path | `/data/git/repositories` |
| Git LFS Root Path | `/data/git/lfs` |
| Run As Username | `git` |
| Server Domain | `git.jafner.net` |
| SSH Server Port | `2225` |
| Gitea HTTP Listen Port | `3000` | 
| Gitea Base URL | `https://git.jafner.net/` |
| Log Path | `/data/gitea/log` |
| SMTP Host | `smtp.protonmail.ch` |
| SMTP Port | `587` |
| Send Email As | `Gitea Admin <noreply@jafner.net>` |
| SMTP Username | `noreply@jafner.net` |
| SMTP Password | See password manager. |
