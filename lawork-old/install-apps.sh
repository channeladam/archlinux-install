#!/bin/bash

# KVM - As per https://wiki.archlinux.org/index.php/Libvirt#Server, install Virtual Machine Manager:
pacman -Syu libvirt qemu samba virt-manager ebtables dnsmasq bridge-utils

# Enable and start the libvirtd daemon
systemctl start libvirtd
systemctl enable libvirtd

# Set the default virtual network to start automatically
virsh net-autostart default



# VM Client
pacman -S remmina freerdp

pacman -S util-linux smartmontools

# code slack-desktop firefox freeoffice inkscape krita 
# evolution evolution-ews



echo "git & kwallet"
pacman -S git ksshaskpass kwalletmanager
git config --global core.askpass /usr/bin/ksshaskpass


