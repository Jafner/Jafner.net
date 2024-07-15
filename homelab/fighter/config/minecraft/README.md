# Setting up a new modded server
We'll use Enigmatica10 for example here.
1. Download the server pack. The specific way to do this varies by pack. 
   1. For E10, this means navigating to the [curseforge page](https://www.curseforge.com/minecraft/modpacks/enigmatica10).
   2. Then scrolling down the right side to find the section for "Server Packs".
   3. Select the most recent (`Enigmatica 10 Server 1.0.1`) pack.
   4. Click the Download button. I assume we're downloading the file to `~/Downloads/`
2. Copy the zip over to Fighter's configured storage location for Minecraft and extract it. 
   1. Find Fighter's configured storage location for Minecraft. `DIR=$(ssh admin@192.168.1.23 cat /home/admin/homelab/fighter/config/minecraft/.env | head -n 1 | cut -d'=' -f2) && echo $DIR`
   2. Copy the zip over. `scp ~/Downloads/Enigmatica10Server-1.0.1.zip admin@192.168.1.23:$DIR`
   3. Extract and then delete the zip. `ssh admin@192.168.1.23 "cd $DIR && mkdir e10 && unzip Enigmatica10Server-1.0.1.zip -d e10 && rm Enigmatica10Server-1.0.1.zip"
3. 

## Workaround for running server on desktop if I can't figure out how to make the container work.
1. Run the server on desktop.
2. Update [router mapping](docker-compose.yml#11) to point at the desktop. E.g. `--mapping=e10.jafner.net=192.168.1.135:25565`
3. Be sad that you couldn't make it work "right".
4. Be glad that you got it working.

# Post-Setup

## Connecting to a server's CLI
To connect to a server's RCON Minecraft console, run
`docker exec -it minecraft_e6 rcon-cli --password thanksitzg`
If you get "Failed to connect to RCON serverrcon: authentication failed", check the `server.properties` values for `enable-rcon` and `rcon.password`.
Do not prefix commands with `/`. 

- https://github.com/itzg/docker-minecraft-server#interactive-and-color-console
- https://github.com/itzg/docker-minecraft-server#use-rcon-commands

## Updating MC-Router mappings
MC-Router must be running for all active MC connections. Restarting it kicks everyone off their servers

To update the mappings while running, use `docker exec minecraft_mc-router /mc-router --mapping <new-mapping string>`

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

## Chunk Pregenerator
Chunk pregeneration is very valuable for getting a playable SMP server expierence. 
### Installing Chunk Pregenerator
Make sure that the [Chunk Pregenerator](https://www.curseforge.com/minecraft/mc-mods/chunkpregenerator) mod is installed. It is compatible with most Minecraft versions between 1.7.2 and 1.16.5.
### Pregenerating World Spawn
To pregen chunks, first connect to the server's RCON CLI. Then, run the following, 
`pregen start gen radius Pregen SQUARE 0 0 100`
This should take about half an hour and will generate about 40,000 chunks (2r^2). 
For a job closer to 8 hours, run
`pregen start gen radius Pregen SQUARE 0 0 500`
Which will generate about 500,000 chunks.

A Ryzen 7 5800X generates chunks at about 1.35 chunks per tick (27 chunks per second @ 20 TPS).

### Automating Chunk Pregen
Itzg's [container supports](https://github.com/itzg/docker-minecraft-server#use-rcon-commands) `RCON_CMDS_FIRST_CONNECT` and `RCON_CMDS_LAST_DISCONNECT` environment variables, which allow us to automatically begin pregenerating chunks when no one is connected, and pause this task when players begin joining.

Use these variables when the server supports pregen and would benefit from this:
```
RCON_CMDS_STARTUP= |-
    /pregen start gen radius Pregen SQUARE 0 0 500
RCON_CMDS_FIRST_CONNECT= |-
    /pregen pause
RCON_CMDS_LAST_DISCONNECT= |-
    /pregen continue
```
This pregen will significantly reduce load on the server during playtime *unless*:
* Players explore beyond the pregenerated regions, or
* Players join the server before a significant area can be pregenerated.
