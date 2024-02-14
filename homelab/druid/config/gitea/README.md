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
PASSWD = [Located at postgres_secrets.env]
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

# Re-register Gitea Runners
To force the runners to re-register (to apply updated labels, for example).

1. Stop and remove the containers. Run `docker ps -aq --filter name="gitea_runner-*" | xargs docker stop | xargs docker rm`. 
2. Delete the `.runner` files for each runner. Run `find ~/data/gitea/ -name ".runner" -delete`.
3. Bring the runners back up. Run `docker compose up -d` from the gitea directory. 

