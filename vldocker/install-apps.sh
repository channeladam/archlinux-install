#!/bin/bash

echo "QEMU Guest Agent"
pacman -S qemu-guest-agent
systemctl enable qemu-guest-agent.service --now

echo "docker"
pacman -S --noconfirm docker 
groupadd docker
usermod -aG docker adam
echo "You will need to sign-out and sign-in for the group membership to take effect and run docker without sudo"
systemctl enable docker
systemctl start docker

echo "openssh"
# https://wiki.archlinux.org/index.php/OpenSSH
pacman -S openssh
systemctl enable sshd.service --now
# ss --tcp --listening | grep ssh
