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

sudo pacman -S --noconfirm downgrade


#########################
# Utilities
#########################

# Antivirus
sudo pacman -S --noconfirm clamav clamtk
yay -S --noconfirm thunar-sendto-clamtk

# Password manager
flatpak install -y flathub org.keepassxc.KeePassXC

# Remmina - use either flatpak or yay for the local microphone to work - not sudo pacman.
flatpak install -y flathub org.remmina.Remmina

# Materia Dark Theme
sudo pacman -S --noconfirm materia-gtk-theme
flatpak install -y flathub org.gtk.Gtk3theme.Materia-dark org.gtk.Gtk3theme.Materia-dark-compact

# KVM - Barrier
flatpak install -y flathub com.github.debauchee.barrier

# GParted
sudo pacman -S --noconfirm gparted dosfstools mtools

# Trash-cli
sudo pacman -S --noconfirm trash-cli

# Night Light
sudo pacman -S --noconfirm redshift

# Back-in-time
sudo pacman -S --noconfirm backintime

# Terminal
sudo pacman -S --noconfirm tilix

# System Monitoring
sudo pacman -S --noconfirm bashtop stacer htop gnome-system-monitor

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
flatpak install -y flathub  org.mozilla.firefox

flatpak install -y flathub flathub com.slack.Slack
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.microsoft.Teams
flatpak install -y flathub us.zoom.Zoom

# Thunderbird and calendar integration
sudo pacman -S --noconfirm thunderbird 
yay -S --noconfirm thunderbird-tvsync
# O365 / Exchange functionality
flatpak install -y flathub org.davmail.DavMail



#########################
# A/V
#########################

# Spotify
flatpak install -y flathub com.spotify.Client

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


#########################
# Software Development
#########################

# git
sudo pacman -S --noconfirm git seahorse libsecret
git config --global credential.helper /usr/lib/git-core/git-credential-libsecret

yay -S --noconfirm github-desktop-bin

# .NET
yay -S --noconfirm dotnet-sdk-bin aspnet-runtime-bin

# VSCode - the official MS version is required (as opposed to OSS ‘code’) in order to be able to debug
yay -S --noconfirm visual-studio-code-bin

# Postman
flatpak install -y flathub com.getpostman.Postman

# Azure Tools
yay -S --noconfirm azuredatastudio
yay -S --noconfirm azure-functions-core-tools-bin

# Python
sudo pacman -S --noconfirm python python-pip
sudo pacman -S --noconfirm pyenv
yay -S --noconfirm pyenv-virtualenv
pip install --upgrade pip

# Docker
sudo pacman -S --noconfirm docker
# Configure docker so that it doesn’t need to run as root:
sudo groupadd docker
sudo usermod -aG docker adam
sudo newgrp docker
sudo systemctl enable --now docker
