#!/bin/bash

torrents_path="/torrenting"
for file in ./*.torrent; do
    announce_url=$(exiftool "$file" | grep Announce | tr -s ' ' | cut -d' ' -f 3)
    category="pub"
    if [[ $announce_url =~ "gazellegames" ]]; then
        category="ggn"
        category_path="$torrents_path/GGN"
        qbt torrent add file --content-layout Subfolder --folder "$category_path" "$file"
    fi
    if [[ $announce_url =~ "myanonamouse" ]]; then
        category="mam"
        category_path="$torrents_path/MAM"
        qbt torrent add file --content-layout Subfolder --folder "$category_path" "$file"
    fi
    if [[ $announce_url =~ "empornium" ]]; then
        category="emp"
        category_path="$torrents_path/EMP/[NEW]"
        qbt torrent add file --content-layout Subfolder --folder "$category_path" "$file"
    fi
done