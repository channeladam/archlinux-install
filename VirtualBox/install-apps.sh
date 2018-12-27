#!/bin/bash

echo "NOTE: This must be run AFTER install-pamac.sh"

echo "AUR package manager - pikaur"
pamac build pikaur

echo "system updater tray icon"
#echo "pamac-tray-appindicator"
#pikaur -S pamac-tray-appindicator
echo "kalu"
pikaur -S kalu

echo "firewall"
pacman -S ufw gufw

echo "apps"
pacman -S chromium firefox code nodejs docker 

echo "openssh"
# https://wiki.archlinux.org/index.php/OpenSSH
pacman -S openssh
systemctl enable sshd.socket
systemctl start sshd.socket
# ss --tcp --listening | grep ssh
