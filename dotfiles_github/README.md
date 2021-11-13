# Cloning the repository
1. Get the SSH key. Save the content of the `.ssh/id_rsa` file to `~/.ssh/id_rsa`
2. Restrict the permissions for the file with `chmod 600 ~/.ssh/id_rsa`
3. Add the key to the agent:
```bash
eval $(ssh-agent -s) && \
ssh-add ~/.ssh/id_rsa
```
4. Clone the repo with `git clone git@github.com:Jafner/dotfiles.git ~/Git/dotfiles`
5. Place the dotfiles where they need to be with `chmod +x install_dotfiles.sh && ./install_dotfiles.sh`

# Other Stuff
## Autostart
1. Set Spotify, PulseEffects, and Ferdi to start automatically.
2. `chmod +x window_reposition.sh`
3. `sudo cp .scripts/window_reposition.sh /usr/bin/window_reposition`
3. Run the window_reposition script at startup.


## Tiling and corner-snapping
Using GNOME, disable all extensions. Install [Tiling Assistant](https://extensions.gnome.org/extension/3733/tiling-assistant/)
Set Windows and Screen Edges gaps to 12px.

## Virtualization
Install `libvirt`.
`nano /etc/default/grub` and add `amd_iommu=on iommu=pt` to the `GRUB_CMDLINE_LINUX_DEFAULT` variable.
`sudo grub-mkconfig -o /boot/grub/grub.cfg` to update the bootloader.
Install QEMU, KVM, libvirt, virtmanager. `sudo pacman -S virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat ovmf`

Configure `libvirtd`

```bash
sudo sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf && \
sudo sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf && \
sudo bash -c 'echo "log_filters=\"1:qemu\"" >> /etc/libvirt/libvirtd.conf' && \
sudo bash -c 'echo "log_outputs=\"1:file:/var/log/libvirt/libvirtd.log\"" >> /etc/libvirt/libvirtd.conf' && \
sudo usermod -aG libvirt $USER && \
sudo systemctl enable libvirtd && \
sudo systemctl start libvirtd && \
sudo sed -i 's/#user = "root"/user = "joey"/' /etc/libvirt/qemu.conf && \
sudo sed -i 's/#group = "root"/group = "joey"/' /etc/libvirt/qemu.conf && \
sudo systemctl restart libvirtd
```

Reboot.

Set up the VM, following the [RisingPrism wiki](https://gitlab.com/risingprismtv/single-gpu-passthrough/-/wikis).

Open Nvidia X Server Settings, go to GPU 0 and check the VBIOS version. 
Browse to https://www.techpowerup.com/vgabios/ and download the correct VBIOS file. 
Rename the file to `vbios.rom`.

Place the VBIOS file.
```bash
sudo mkdir /usr/share/vbios && \
sudo cp ~/Downloads/vbios.rom /usr/share/vbios/vbios.rom && \
cd /usr/share/vbios && \
sudo chmod -R 660 vbios.rom && \
sudo chown joey:joey vbios.rom
```

