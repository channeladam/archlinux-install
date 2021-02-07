#!/bin/bash

sudo pacman -Syu --noconfirm

#########################
# Remote access
#########################

# SSH
sudo pacman -S --noconfirm openssh
sudo systemctl enable --now sshd.service


#########################
# Disk tools
#########################

# Disk mounting - mount.smb3
sudo pacman -S --noconfirm gvfs gvfs-smb smbclient cifs-utils

# SSDs & SMART
sudo pacman -S --noconfirm smartmontools

# Periodic TRIM
sudo pacman -S --noconfirm util-linux
sudo systemctl enable --now fstrim.timer


#########################
# Application Managers
#########################
sudo pacman -S --noconfirm flatpak
flatpak install -y flathub flatseal

# Downgrade
sudo pacman -S --noconfirm downgrade


#########################
# Utilities
#########################

# Partition Tools
sudo pacman -S --noconfirm gparted dosfstools mtools

# Backup tools
sudo pacman -S --noconfirm partclone rsync rclone

# Trash-cli
sudo pacman -S --noconfirm trash-cli

# System Monitoring
sudo pacman -S --noconfirm bashtop htop

# Nvidia related
sudo mhwd -i pci video-nvidia
sudo pacman -S --noconfirm nvtop

# Virtual display
# Usage:
# (a)
#     $ xvfb-run --auto-display <command>
# or
# (b)
#     $ Xvfb :1 -screen 0 1920x1080x24+32 -fbdir /tmp &
#     $ export DISPLAY=:1
sudo pacman -S --noconfirm xorg-server-xvfb

# QEMU Guest Agent
pacman -S qemu-guest-agent
systemctl enable qemu-guest-agent.service --now


#########################
# Software Development
#########################

# git
sudo pacman -S --noconfirm git seahorse libsecret
git config --global credential.helper /usr/lib/git-core/git-credential-libsecret

# .NET
yay -S --noconfirm dotnet-sdk-bin aspnet-runtime-bin

# PowerShell
yay -S --noconfirm powershell-bin

# Python
sudo pacman -S --noconfirm python python-pip
sudo pacman -S --noconfirm pyenv
yay -S --noconfirm pyenv-virtualenv
pip install --upgrade pip

# Kubectl, kubectx and kubens
sudo pacman -S --noconfirm kubectl kubectx

# Helm
sudo pacman -S --noconfirm helm

# Minikube
sudo pacman -S --noconfirm minikube

# Docker
# See https://docs.docker.com/install/linux/linux-postinstall/
sudo pacman -S --noconfirm docker
# Configure docker so that it doesn’t need to run as root:
sudo groupadd docker
sudo usermod -aG docker adam
sudo newgrp docker
sudo systemctl enable --now docker

# Docker credential helper - secretservice
# https://docs.docker.com/engine/reference/commandline/login/#credentials-store
# https://github.com/docker/docker-credential-helpers
# Then you can do a "docker login" with the credentials stored securely.
yay -S --noconfirm docker-credential-secretservice
cat <<EOF > ~/.docker/config.json
{
  "credsStore": "secretservice"
}
EOF

# nodejs
sudo pacman -S --noconfirm nodejs

# Azure Artifacts Credential Provider
# https://github.com/microsoft/artifacts-credprovider#azure-artifacts-credential-provider
# Used indirectly with "dotnet restore --interactive"
wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash

# Azure Tools (needs Python etc installed first)
yay -S --noconfirm azure-cli
yay -S --noconfirm azure-functions-core-tools-bin
yay -S --noconfirm bicep-bin
