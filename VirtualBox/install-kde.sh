#!/bin/bash

echo "installing xorg"
pacman -S xorg

echo "installing virtualbox guest additions"
# https://wiki.archlinux.org/index.php/VirtualBox#Install_the_Guest_Additions
pacman -S virtualbox-guest-dkms virtualbox-guest-utils

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
# pacman -S lightdm
# systemctl enable lightdm

echo "git"
pacman -S git

echo "sound"
# https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture
echo "options snd-intel8x0 ac97_clock=48000" >> /etc/modprobe.d/alsa-base.conf
pacman -S alsa-utils alsa-oss alsa-firmware
amixer sset Master unmute
amixer sset PCM unmute
#alsamixer
pulseaudio -k
#speaker-test -c 2
