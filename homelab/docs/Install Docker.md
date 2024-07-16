Debian (and derivatives)
```bash
sudo apt update && sudo apt upgrade && \
sudo apt install git docker docker-compose && \
sudo systemctl enable docker && \
sudo usermod -aG docker $USER && \
logout
```

Arch (and derivatives)
```bash
sudo pacman -Syu && \
sudo pacman -S git docker docker-compose && \
sudo systemctl enable docker && \
sudo usermod -aG docker $USER && \
logout
```