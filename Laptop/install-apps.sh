#!/bin/bash

# KVM - As per https://wiki.archlinux.org/index.php/Libvirt#Server, install Virtual Machine Manager:
pacman -Syu libvirt qemu samba virt-manager ebtables dnsmasq bridge-utils

# Enable and start the libvirtd daemon
systemctl start libvirtd
systemctl enable libvirtd

# VM Client
pacman -S remmina freerdp



echo "git & kwallet"
pacman -S git ksshaskpass kwalletmanager
git config --global core.askpass /usr/bin/ksshaskpass


