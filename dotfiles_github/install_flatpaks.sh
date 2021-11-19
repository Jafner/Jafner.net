for app in ./.flatpak/*
do
    flatpak install -y $app
done
