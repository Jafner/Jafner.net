host = input("Enter host (e.g. 'localhost:8080'): ")
username = input("Enter username: ")
password = input("Enter password: ")

from qbittorrent-api import Client
client = Client(host=host, username=username, password=password)

torrent_list = client.torrents.info()

for torrent in torrent_list:
    for status in torrent.trackers:
        if 'Unregistered torrent' in status.msg:
            print(torrent.name)
            torrent.delete(hash=(torrent.hash),delete_files=True)
