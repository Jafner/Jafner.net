#!/bin/bash

# echo back all commands (for debugging)
set -x

# install virtualization packages
sudo pacman -S virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat ovmf

# edit default grub config and apply
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash apparmor=1 security=apparmor udev.log_priority=3"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash apparmor=1 security=apparmor amd_iommu=on iommu=pt udev.log_priority=3"/' /etc/default/grub && \
sudo grub-mkconfig -o /boot/grub/grub.cfg

# edit libvirtd.conf 
sudo sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf && \
sudo sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf && \
sudo bash -c 'echo "log_filters=\"1:qemu\"" >> /etc/libvirt/libvirtd.conf' && \
sudo bash -c 'echo "log_outputs=\"1:file:/var/log/libvirt/libvirtd.log\"" >> /etc/libvirt/libvirtd.conf' && \

# add self to libvirt group, setup libvirtd systemd unit
sudo usermod -aG libvirt $USER && \
sudo systemctl enable libvirtd && \
sudo systemctl start libvirtd && \

# edit user and group for qemu
sudo sed -i 's/#user = "root"/user = "joey"/' /etc/libvirt/qemu.conf && \
sudo sed -i 's/#group = "root"/group = "joey"/' /etc/libvirt/qemu.conf && \

# apply libvirtd changes
sudo systemctl restart libvirtd


cd .virtualization


# dump gpu vbios
#source dump_rom.sh

# import patched vbios
sudo chmod -R 660 vbios_patched.rom
sudo chown joey:joey vbios_patched.rom
sudo mkdir -p /usr/share/vbios && sudo cp vbios_patched.rom /usr/share/vbios/vbios.rom

# import vm parameters
sudo cp ./.virtualization/win10.xml /etc/libvirt/qemu/win10.xml
sudo chown root:root /etc/libvirt/qemu/win10.xml 
sudo chmod 600 /etc/libvirt/qemu/win10.xml

# autostart default network
sudo virsh net-autostart default

# install hooks
sudo chmod +x start.sh stop.sh qemu
sudo mkdir -p /etc/libvirt/hooks && sudo cp qemu /etc/libvirt/hooks/qemu
sudo cp start.sh /bin/start.sh
sudo cp stop.sh /bin/stop.sh

