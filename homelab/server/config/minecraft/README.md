## Connecting to a server's CLI
`docker exec -it <container_name> rcon-cli --password thanksitzg`
https://github.com/itzg/docker-minecraft-server#interactive-and-color-console
https://github.com/itzg/docker-minecraft-server#use-rcon-commands

## Updating MC-Router mappings
MC-Router must be running for all active MC connections. Restarting it kicks everyone off their servers

To update the mappings while running, use `docker exec mc-router /mc-router --mapping <new-mapping string>`

## Before Starting a Server
Check the following server.properties values:
| Parameter | Value | Why |
|:--:|:--:|:--:|
| `allow-flight` | true | Many modded features trigger Minecraft's flight detection. Allow flight to prevent wrongful bans.
| `enable-rcon` | true | This overrides any rcon settings in the compose file. Enable rcon to interact with the server's command line |
| `max-tick-time` | 600 normally, 120000 when pre-genning chunks | Increase the max tick time to prevent the hang watchdog from killing the server when pregenning chunks |
| `rcon.password` | `thanksitzg` | Set a simple password to protect the rcon port |
| `rcon.port` | `25575` | Set this to what itzg's rcon-cli expects as default |
| `view-distance` | 10 for lightweight servers, 6 for heavy servers | View distance has great impact on server load |