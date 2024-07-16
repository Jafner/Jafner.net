connection_info = dict(
    host = input("Enter host (e.g. 'localhost'): "),
    port = input("Enter port (e.g. '8080'): "),
    username = input("Enter username: "),
    password = input("Enter password: "),
)

from hurry.filesize import size, si

import qbittorrentapi
client = qbittorrentapi.Client(**connection_info)

try:
    client.auth_log_in()
except qbittorrentapi.LoginFailed as error:
    print(error)

torrent_list = client.torrents.info()

for torrent in torrent_list:
    for status in torrent.trackers:
        if 'UNREGISTERED TORRENT' in status.msg.upper() or 'TORRENT NOT REGISTERED' in status.msg.upper():
            print(torrent.name, size(torrent.size, system=si))
            torrent.delete(hash=(torrent.hash),delete_files=True)