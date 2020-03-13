#!/bin/bash

echo "NOTE: This must be run AFTER install-pamac.sh"

echo "AUR package manager - pikaur"
pamac build pikaur
#pamac build yay

echo "system updater tray icon"
#echo "pamac-tray-appindicator"
#pikaur -S pamac-tray-appindicator
echo "kalu"
pikaur -S kalu

echo "firewall"
pacman -S ufw gufw

echo "misc apps"
pacman -S tilix firefox nodejs npm hunspell hunspell-en_AU 

#echo "screen snapshot - KDE"
#pacman -S spectacle

pikaur -S google-chrome visual-studio-code-bin

echo "docker"
pacman -S docker 
groupadd docker
usermod -aG docker adam
echo "You will need to sign-out and sign-in for the group membership to take effect and run docker without sudo"
systemctl enable docker
systemctl start docker

echo "openssh"
# https://wiki.archlinux.org/index.php/OpenSSH
pacman -S openssh
systemctl enable sshd.socket
systemctl start sshd.socket
# ss --tcp --listening | grep ssh
