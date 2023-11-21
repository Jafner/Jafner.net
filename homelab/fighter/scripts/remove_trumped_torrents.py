connection_info = dict(
    host = input("Enter host (e.g. 'localhost'): "),
    port = input("Enter port (e.g. '8080'): "),
    username = input("Enter username: "),
    password = input("Enter password: "),
)

import qbittorrentapi
client = qbittorrentapi.Client(**connection_info)

try:
    client.auth_log_in()
except qbittorrentapi.LoginFailed as error:
    print(error)

torrent_list = client.torrents.info()

for torrent in torrent_list:
    for status in torrent.trackers:
        if 'Unregistered torrent' in status.msg:
            print(torrent.name)
            torrent.delete(hash=(torrent.hash),delete_files=True)
