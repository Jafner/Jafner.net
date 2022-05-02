## Connecting to a server's CLI
`docker attach e6`
https://github.com/itzg/docker-minecraft-server#interactive-and-color-console
https://github.com/itzg/docker-minecraft-server#interactive-and-color-console
https://github.com/itzg/docker-minecraft-server#use-rcon-commands

## Updating MC-Router mappings
MC-Router must be running for all active MC connections. Restarting it kicks everyone off their servers

To update the mappings while running, use `docker exec mc-router /mc-router --mapping <new-mapping string>`