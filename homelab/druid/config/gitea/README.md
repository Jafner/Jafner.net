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