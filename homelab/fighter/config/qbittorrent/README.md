## Create a Torrent File
On Windows, use qBitTorrent's [Torrent Creator](https://www.ghacks.net/2019/09/20/how-to-create-a-private-torrent-using-qbittorrent/)  
On Linux (CLI), use [`ctorrent`](http://manpages.ubuntu.com/manpages/bionic/man1/ctorrent.1.html). (Like: `ctorrent -t -s output_file.torrent /path/to/source/dir`)

## Update Tracker URLs in Bulk
Requires: [qbittorrent-cli](https://github.com/fedarovich/qbittorrent-cli)

0. Configure `qbt` to connect to `qbt.jafner.net`.
```
qbt settings set username admin
qbt settings set url https://qbt.jafner.net
```

1. Get a list of hashes for torrents of the right category.
Example: `qbt torrent list --category ggn --format json | jq ' .[].hash' | tr -d '"' > hashes.txt`

2. Replace the old announce URL with the new announce URL for each hash. 
Example: `for hash in $(cat hashes.txt); do qbt torrent tracker edit $hash "https://tracker.gazellegames.net/7667910c8a2b5446890cbd0ad459d5c3/announce" "https://tracker.gazellegames.net/d0dd178494dd6ffcd9842934a13086e0/announce"; done`
This will take a long time.

## Check Sum Torrent Size by Category
BEHOLD. MY ONE LINER: `for category in $(qbt category list --format json | jq -r '.[].name'); do qbt torrent list --category $category --format json | jq ' .[].size' > sizes_$category.txt && echo $category && awk '{ sum += $1 } END { print sum }' sizes_$category.txt | numfmt --to=iec-i --suffix=B --format="%9.2f"; done`

## Check for "Unregistered" (Trumped/Deleted) Torrents
Many private trackers will delete or trump (replace with better quality) torrents. These trackers have no way to directly inform your torrent client that the torrent is no longer valid, but can update the way the tracker responds to announce messages from your client. For many Gazelle-based trackers, this is done by responding with "Unregistered torrent" in the message field, and setting the status to "Not working". Qbittorrent does not provide functionality in the WebUI to quickly and easily find all unregistered torrents, but the API does support the idea.  

User `animosity22` posted a quick python script [on Github](https://github.com/qbittorrent/qBittorrent/issues/11469#issuecomment-553459887) to find, print, and delete all torrents with the 'Unregistered torrent' message from the tracker.  

But that script used hardcoded credentials for host, username, and password. We don't want that if it will be entered into version control. So I had ChatGPT rewrite the script for me to make those user-inputted. It can be found [here](../../scripts/remove_trumped_torrents.py).

### Using the Script
Prerequisites: 
- a Python3 environment
- the `qbittorrent-api` package
- the `hurry.filesize` package

Steps:
1. Get the URL of the Qbittorrent webUI. `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' qbittorrent_qbittorrent`. We'll assume the default port of `8080` for the webUI here.
2. Get the username and password for the webUI. These should be in a password manager.
3. Run the script `python3 ~/homelab/fighter/scripts/remove_trumped_torrents.py`. When prompted, input the `host` like `172.18.0.28:8080` with the IP found in step 1. Use the credentials from step 2 for username and password.
4. Done.
