# `app.ini` Snippets 
The main Gitea config file is located at `~/data/gitea/gitea/gitea/conf/app.ini`.

Configure connection to postgres DB container.
```
[database]
PATH = /data/gitea/gitea.db
DB_TYPE = postgres
HOST = postgres:5432
NAME = gitea
USER = gitea
PASSWD = [From postgres.secrets]
LOG_SQL = false
SCHEMA = 
SSL_MODE = disable
```

Disable OpenID as login option.
```
[openid]
ENABLE_OPENID_SIGNIN = false
ENABLE_OPENID_SIGNUP = false
```

Allow migrating from specific domains.
```
[migrations]
ALLOWED_DOMAINS = gitlab.jafner.net, *.github.com, github.com
```

Configure SMTP email.
```
[mailer]
ENABLED = true
FROM = Gitea
PROTOCOL = smtp+starttls
SMTP_ADDR = smtp.protonmail.ch
SMTP_PORT = 587
USER = noreply@jafner.net
PASSWD = `****************`
```

## Apply changes
Just restart the container.
`cd ~/homelab/druid/config/gitea && docker compose up -d --force-recreate`


# Re-register Gitea Runners
To force the runners to re-register (to apply updated labels, for example).

1. Stop and remove the containers. Run `docker ps -aq --filter name="gitea_runner-*" | xargs docker stop | xargs docker rm`. 
2. Delete the `.runner` files for each runner. Run `find ~/data/gitea/ -name ".runner" -delete`.
3. (Optional) Update runner config. Modify the `config.yaml` file as needed. [Official example config](https://gitea.com/gitea/act_runner/src/branch/main/internal/pkg/config/config.example.yaml).
4. Bring the runners back up. Run `docker compose up -d` from the gitea directory. 

# Delete Registed Runners
Apparently a misconfigured Docker-in-Docker runner may sometimes retry registering over and over until the heat death of the universe. In that case you will end up with many "ghost" runners. In my case, 27,619. To resolve, you can either step through each one and click "edit", then "delete", then "confirm". Or you can just use the database. 

1. `docker exec -it gitea_postgres psql --username "gitea"` To open a terminal inside the container and open a CLI session to the database.
2. `\c gitea` To select the 'gitea' database.
3. `DELETE FROM action_runner WHERE id NOT IN (50, 66);` To delete all entries except those with the IDs I wanted to keep.

# Disable native auth
We don't want to use Gitea's native auth. We want Keycloak to handle all our authentication. So we place a template override in the correct directory, which Gitea picks up on startup to generate the signin page. 

The file [`signin_inner.tmpl`](signin_inner.tmpl) must be placed into `/data/gitea/templates/user/auth/` *inside the container*. In our case, that means `~/data/gitea/gitea/gitea/templates/user/auth/` on the host system. 

For this to work properly, we use the following `app.ini` snippets:

```ini
[service]
DISABLE_REGISTRATION = true
ALLOW_ONLY_EXTERNAL_REGISTRATION = true

[openid]
ENABLE_OPENID_SIGNIN = false
ENABLE_OPENID_SIGNUP = false

[oauth2_client]
ENABLE_AUTO_REGISTRATION = true
ACCOUNT_LINKING = disabled
```