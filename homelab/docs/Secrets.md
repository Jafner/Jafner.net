# Secrets
Our repository contains as many configuration details as reasonable. But we must secure our secrets: passwords, API keys, encryption seeds, etc..  

## Docker Env Vars
1. We store our Docker env vars in a file named after the service. For example `keycloak.env`. 
2. We separate our secrets from non-secret env vars by placing them in a file with a similar name, but with `_secrets` appended to the service name. For example `keycloak_secrets.env`. These files exist only on the host for which they are necessary, and must be created manually on the host. 
3. Our repository `.gitignore` excludes all files matching `*.secret`, and `*_secrets.env`. 

Note: This makes secrets very fragile. Accidental deletion or other data loss can destroy the secret permanently.

## Generating Secrets
We use the password manager's generator to create secrets with the desired parameters, preferring the following parameters:
    - 64 characters
    - Capital letters, lowercase letters, numbers, and standard symbols (`^*@#!&$%`)
If necessary, we will reduce characterset by cutting out symbols before reducing string length.
