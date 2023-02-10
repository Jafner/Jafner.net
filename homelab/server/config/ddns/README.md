# Updating ddclient.conf
ddclient does not natively support proper secret management for credentials. So in order to ensure that our DNS management credentials are not kept in Git, we have to work around that. 

Our credentials are stored in `ddclient_secrets.env`, which is git-ignored. Additionally, the actual `ddclient.conf` file is git-ignored because it must contain the credentials. 

So we generate the config file when it must be updated. To update the file, we can run the following command:  

```bash
cd ~/homelab/server/config/ddns/ && \
export $(cat ddclient_secrets.env | xargs) && \
envsubst < ./ddclient/ddclient.template > ./ddclient/ddclient.conf && \
unset $(grep -v '^#' ddclient_secrets.env | sed -E 's/(.*)=.*/\1/' | xargs) && \
docker-compose up -d --force-recreate
```

First we export the variables in the `ddclient_secrets.env` file (which are all simple key-value pairs). Then, the [`envsubst`](https://www.baeldung.com/linux/envsubst-command) command looks for env variable references (like `$USER_Jafner_chat`) in the `ddclient.template` file (via stdin) and replaces them with the values from the current shell. We remove the secrets from the shell to preserve security. Finally, we recreate the container to apply the new settings.

[StackOverflow - Set environment variables from file of ke/value pairs](https://stackoverflow.com/questions/19331497/set-environment-variables-from-file-of-key-value-pairs)