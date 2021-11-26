# Objective
Minimize the amount of manual work to configure a fresh Manjaro KDE installation to my liking.

# Start with a `sudo pacman -Syu`

# Cloning the repository
1. Get the SSH key. Save the content of the `.ssh/id_rsa` file to `~/.ssh/id_rsa`
2. Restrict the permissions for the file with `chmod 600 ~/.ssh/id_rsa`
3. Add the key to the agent:
```bash
eval $(ssh-agent -s) && \
ssh-add ~/.ssh/id_rsa
```
4. Clone the repo with `git clone git@github.com:Jafner/dotfiles.git ~/Git/dotfiles`
5. Update the system with `sudo pacman -Syu`

# Installing Dotfiles
## Set Up SSHD
Run `chmod +x ./setup_sshd.sh && ./setup_sshd.sh`

## Install Flatpaks
Run `chmod +x ./install_flatpaks.sh && ./install_flatpaks.sh`
You will need to accept some prompts.

```
mkdir -p ~/.themes && cp -r /usr/share/themes/Breeze-Dark ~/.themes/
sudo flatpak override --filesystem=~/.themes
```

## Install `pamidi`
Install `xdotool` with `sudo pacman -S xdotool`
Run `chmod +x ./install_pamidi.sh && ./install_pamidi.sh`

## Install Lutris
Just run `chmod +x ./install_lutris.sh && ./install_lutris.sh` It's so many packages oh my god

## Install other applications


# Other Stuff

## Set Flatpaks to use Breeze-Dark Gtk3 Theme
`flatpak install flathub org.gtk.Gtk3theme.Breeze-Dark`

## Ferdi
Configure Ferdi by logging into Ferdi sync. This will set up the basic apps, but custom apps will still need to be copied into the dev recipes folder.

Add the custom recipes (with `mkdir -p ~/.var/app/com.getferdi.Ferdi/config/Ferdi/recipes/dev && cp -r ~/Git/dotfiles/.var/app/com.getferdi.Ferdi/config/Ferdi/recipes/dev ~/.var/app/com.getferdi.Ferdi/config/Ferdi/recipes/dev`).

## Autostart
1. Set Spotify, PulseEffects, and Ferdi to start automatically.
2. `chmod +x window_reposition.sh`
3. `sudo cp .scripts/window_reposition.sh /usr/bin/window_reposition`
3. Run the window_reposition script at startup.

## Tiling and corner-snapping for GNOME Desktop
Using GNOME, disable all extensions. Install [Tiling Assistant](https://extensions.gnome.org/extension/3733/tiling-assistant/)
Set Windows and Screen Edges gaps to 12px.

## Virtualization

Steps 1 through 4 can be handled automatically by running `install_virtualization.sh`.

1. Install necessary packages.
`sudo pacman -S virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat ovmf`

2. Prepare the bootloader (GRUB)
```bash
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash apparmor=1 security=apparmor udev.log_priority=3"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash apparmor=1 security=apparmor amd_iommu=on iommu=pt udev.log_priority=3"/' /etc/default/grub && \
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

3. Configure `libvirtd`

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

4. Dump the GPU vbios.
Run the script to dump the vbios.

5. Patch the GPU vbios with Bless Hex Editor.
Follow [Mutahar's guide](https://youtu.be/BUSrdUoedTo?t=874) (timestamped) for this bit.
Save the patched version as `vbios_patched.rom`. Restrict its permissions with `chmod 660 vbios_patched.rom && sudo chown joey:joey vbios_patched.rom` then copy it to the share folder with `sudo mkdir /usr/share/vbios && sudo cp vbios_patched.rom /usr/share/vbios/vbios.rom`

6. Set up the VM.
Follow page 5 of the [RisingPrism wiki](https://gitlab.com/risingprismtv/single-gpu-passthrough/-/wikis/) for details on configuring the VM. 

7. Reboot to effect the changes we made to the bootloader.
