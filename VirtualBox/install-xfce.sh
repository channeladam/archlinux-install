#!/bin/bash

echo "installing xorg"
pacman -S xorg

echo "installing virtualbox guest additions"
# https://wiki.archlinux.org/index.php/VirtualBox#Install_the_Guest_Additions
pacman -S virtualbox-guest-dkms virtualbox-guest-utils
# systemctl enable vboxservice
usermod -a -G vboxsf adam

echo "installing vmware video driver - assuming you are using the VirtualBox VMSVGA display"
# Assuming the use of the VMSVGA display driver in VirtualBox 6
#lspci | grep -e VGA -e 3D
#00:02.0 VGA compatible controller: VMware SVGA II Adapter
pacman -S xf86-video-vmware

echo "installing xfce4"
pacman -S xfce4 

echo "installing some of the xfce goodies"
pacman -S thunar-archive-plugin xfce4-battery-plugin xfce4-clipman-plugin xfce4-cpugraph-plugin xfce4-datetime-plugin xfce4-diskperf-plugin xfce4-mount-plugin xfce4-notifyd xfce4-screensaver xfce4-systemload-plugin xfce4-taskmanager xfce4-whiskermenu-plugin xfce4-artwork
pacman -S xfce4-power-manager

echo "install materia theme"
pacman -S materia-gtk-theme

echo "install breeze theme and icons - primarily for the Breeze Dark icons"
pacman -S breeze-gtk breeze-icons

echo "install lightdm display manager"
pacman -S lightdm lightdm-gtk-greeter
systemctl enable lightdm

echo "install git"
pacman -S git seahorse libsecret
git config --global credential.helper /usr/lib/git-core/git-credential-libsecret

echo "install sound"
# https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture
echo "options snd-intel8x0 ac97_clock=48000" >> /etc/modprobe.d/alsa-base.conf
pacman -S alsa-utils alsa-oss alsa-firmware pulseaudio
amixer sset Master unmute
amixer sset PCM unmute
#alsamixer
pulseaudio -k
#speaker-test -c 2
