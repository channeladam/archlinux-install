#!/bin/bash

echo "installing xorg"
pacman -S xorg

echo "installing virtualbox guest additions"
pacman -S virtualbox-guest-modules-arch virtualbox-guest-utils

echo "installing vmware video driver - assuming you are using the VirtualBox VMSVGA display"
# Assuming the use of the VMSVGA display driver in VirtualBox 6
#lspci | grep -e VGA -e 3D
#00:02.0 VGA compatible controller: VMware SVGA II Adapter
pacman -S xf86-video-vmware

echo "installing Plasma"
echo "note: upstream prefers the vlc phonon backend"
pacman -S plasma kdebase-meta

echo "display manager"
pacman -S sddm
systemctl enable sddm

echo "git"
pacman -S git
