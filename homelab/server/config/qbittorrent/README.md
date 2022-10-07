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