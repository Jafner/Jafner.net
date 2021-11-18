#!/bin/bash

sudo pacman -S virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat ovmf

sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash apparmor=1 security=apparmor udev.log_priority=3"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash apparmor=1 security=apparmor amd_iommu=on iommu=pt udev.log_priority=3"/' /etc/default/grub && \
sudo grub-mkconfig -o /boot/grub/grub.cfg

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

source ./.virtualization/dump_rom.sh

sudo cp ./.virtualization/win10.xml /etc/libvirt/qemu/win10.xml
sudo chown root:root /etc/libvirt/qemu/win10.xml 
sudo chmod 600 /etc/libvirt/qemu/win10.xml
