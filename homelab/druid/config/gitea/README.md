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

# Delete Registed Runners
Apparently a misconfigured Docker-in-Docker runner may sometimes retry registering over and over until the heat death of the universe. In that case you will end up with many "ghost" runners. In my case, 27,619. To resolve, you can either step through each one and click "edit", then "delete", then "confirm". Or you can just use the database. 

1. `docker exec -it gitea_postgres psql --username "gitea"` To open a terminal inside the container and open a CLI session to the database.
2. `\c gitea` To select the 'gitea' database.
3. `DELETE FROM action_runner WHERE id NOT IN (50, 66);` To delete all entries except those with the IDs I wanted to keep.
