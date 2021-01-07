#!/bin/bash

sudo pacman -Syu --noconfirm

#########################
# Disk tools
#########################

# NVMe disks, SSDs & SMART
sudo pacman -S --noconfirm nvme-cli smartmontools

# Periodic TRIM
sudo pacman -S --noconfirm util-linux
sudo systemctl enable --now fstrim.timer


#########################
# Application Managers
#########################
sudo pacman -S --noconfirm flatpak pamac-flatpak-plugin
flatpak install -y flathub flatseal

# App-Outlet AppImage https://app-outlet.github.io/
mkdir -p /home/adam/Applications/
export filename=$(curl -sI https://appoutlet.herokuapp.com/download/appimage | grep 'Location:' | sed -E 's/.*\/releases\/download\/v.*\/(\S*).*$/\1/')
curl -JLO https://appoutlet.herokuapp.com/download/appimage -o /home/adam/Applications/$filename
chmod +x ./$filename

# Downgrade
sudo pacman -S --noconfirm downgrade

# Make websites appear as their own apps - https://github.com/linuxmint/webapp-manager
# Use with Chromium, not FireFox! (buggy)
yay -S --noconfirm webapp-manager


#########################
# Utilities
#########################

# Bluetooth tools
sudo pacman -S --noconfirm manjaro-bluetooth

# Antivirus
sudo pacman -S --noconfirm clamav clamtk
yay -S --noconfirm thunar-sendto-clamtk

# Password manager
flatpak install -y flathub org.keepassxc.KeePassXC

# Remmina - use either flatpak or yay for the local microphone to work - not sudo pacman.
flatpak install -y flathub org.remmina.Remmina

# Materia Dark Theme
sudo pacman -S --noconfirm materia-gtk-theme
# Flatpak themes must be exactly the same as currently configured on the host...
# sudo is needed for flatpak themes apparently.
sudo flatpak install -y flathub org.gtk.Gtk3theme.Materia-dark org.gtk.Gtk3theme.Materia-dark-compact

# KVM - Barrier - need via pacman to have config file loaded correctly on a client
sudo pacman -S barrier

# Partition Tools
sudo pacman -S --noconfirm gparted dosfstools mtools partclone

# Trash-cli
sudo pacman -S --noconfirm trash-cli

# Night Light
sudo pacman -S --noconfirm redshift

# Back-in-time
sudo pacman -S --noconfirm backintime

# Terminal
sudo pacman -S --noconfirm tilix

# System Monitoring
sudo pacman -S --noconfirm xfce4-systemload-plugin bashtop stacer htop gnome-system-monitor

# Calculator
flatpak install -y flathub org.gnome.Calculator


#########################
# Virtual Machines
#########################

# KVM - As per https://wiki.archlinux.org/index.php/Libvirt#Server, install Virtual Machine Manager:
sudo pacman -S --noconfirm libvirt qemu samba virt-manager ebtables dnsmasq bridge-utils

# Enable and start the libvirtd daemon
sudo systemctl enable --now libvirtd

# Set the default virtual network to start automatically
virsh net-autostart default


#########################
# Internet & Communications
#########################

# Use pacman for firefox instead of flatpak due to keepass plugin
# Use pacman for chromium instead of flatpak due to webapp manager
sudo pacman -S --noconfirm firefox chromium

yay -S --noconfirm google-chrome

flatpak install -y flathub flathub com.slack.Slack
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.microsoft.Teams
flatpak install -y flathub us.zoom.Zoom

# Thunderbird and calendar integration
sudo pacman -S --noconfirm thunderbird 
# O365 / Exchange functionality
flatpak install -y flathub org.davmail.DavMail


#########################
# Software Development
#########################

# git
sudo pacman -S --noconfirm git seahorse libsecret
git config --global credential.helper /usr/lib/git-core/git-credential-libsecret

yay -S --noconfirm github-desktop-bin

# .NET
yay -S --noconfirm dotnet-sdk-bin aspnet-runtime-bin

# PowerShell
yay -S --noconfirm powershell-bin

# VSCode - the official MS version is required (as opposed to OSS ‘code’) in order to be able to debug
yay -S --noconfirm visual-studio-code-bin

# Postman
flatpak install -y flathub com.getpostman.Postman

# Azure Artifacts Credential Provider
# https://github.com/microsoft/artifacts-credprovider#azure-artifacts-credential-provider
# Used indirectly with "dotnet restore --interactive"
wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash

# Azure Tools
yay -S --noconfirm azure-cli
yay -S --noconfirm azuredatastudio
yay -S --noconfirm azure-functions-core-tools-bin
yay -S --noconfirm storageexplorer
yay -S --noconfirm bicep-bin

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


#########################
# A/V
#########################

# Spotify
flatpak install -y flathub com.spotify.Client

# Deezer
yay -S --noconfirm deezer

# VLC
flatpak install -y flathub org.videolan.VLC


#########################
# Graphics
#########################
flatpak install -y flathub org.kde.krita
flatpak install -y flathub org.inkscape.Inkscape


#########################
# Office
#########################

flatpak install -y flathub org.libreoffice.LibreOffice
