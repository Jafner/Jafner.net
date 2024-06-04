FLATPAKS="
org.mozilla.firefox 
org.chromium.Chromium 
com.google.Chrome
org.flameshot.Flameshot
com.valvesoftware.Steam
net.lutris.Lutris
com.nextcloud.desktopclient.nextcloud
com.obsproject.Studio
md.obsidian.Obsidian
com.spotify.Client
org.videolan.VLC
com.vscodium.codium
"

for flatpak in $(echo "$FLATPAKS"); do echo "Installing: $flatpak" && flatpak install -y $flatpak; done