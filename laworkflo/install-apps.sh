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
sudo pacman -S --noconfirm flatpak pamac-cli pamac-gtk pamac-flatpak-plugin
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

# Logitech Unifying Receiver tools
sudo pacman -S --noconfirm solaar

# Antivirus
sudo pacman -S --noconfirm clamav clamtk
yay -S --noconfirm thunar-sendto-clamtk

# Password manager
flatpak install -y flathub org.keepassxc.KeePassXC

# Remmina - use either flatpak or yay for the local microphone to work - not sudo pacman.
flatpak install -y flathub org.remmina.Remmina

# Virt-viewer for Proxmox Spice connections
flatpak install -y flathub org.virt_manager.virt-viewer
echo 'NOTE: You will need to create a .desktop file containing "exec=flatpak run org.virt_manager.virt-viewer"'

# Materia Dark Theme
sudo pacman -S --noconfirm materia-gtk-theme
# Flatpak themes must be exactly the same as currently configured on the host...
# sudo is needed for flatpak themes apparently.
sudo flatpak install -y flathub org.gtk.Gtk3theme.Materia-dark org.gtk.Gtk3theme.Materia-dark-compact

# KVM - Input Leap - need via yay to have config file loaded correctly on a client - https://github.com/input-leap/input-leap
yay -S --noconfirm input-leap-git

# Partition Tools
sudo pacman -S --noconfirm gparted dosfstools mtools

# Disk Space
sudo pacman -S --noconfirm filelight

# Backup tools
sudo pacman -S --noconfirm partclone rsync rclone backintime 
yay -S --noconfirm rclone-browser
flatpak install -y flathub org.freefilesync.FreeFileSync

# Trash-cli
sudo pacman -S --noconfirm trash-cli

# Night Light
sudo pacman -S --noconfirm redshift

# Terminal
sudo pacman -S --noconfirm tilix

# System Monitoring
sudo pacman -S --noconfirm xfce4-systemload-plugin bashtop stacer htop gnome-system-monitor

# Diagnostics
sudo pacman -S strace

# Calculator
flatpak install -y flathub org.gnome.Calculator

# Time tracking
flatpak install -y flathub org.kde.ktimetracker

# Downloading
flatpak install -y flathub org.qbittorrent.qBittorrent
flatpak install -y flathub org.nickvision.tubeconverter

# Webcam
# NOTE: also need the linux headers installed to run fake-background
sudo pacman -S --noconfirm guvcview-qt
yay -S --noconfirm fake-background-webcam-git python-pyinotify inotify-tools
flatpak install -y flathub io.github.webcamoid.Webcamoid
# pip install inotify_simple configargparse cv2


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

# Use pacman for vivaldi instead of flatpak due to keepass plugin
sudo pacman -S --noconfirm vivaldi-bin vivaldi-ffmpeg-codecs

# Install Brave to use as a privacy browser
flatpak install -y flathub com.brave.Browser

# Use pacman for firefox instead of flatpak due to keepass plugin
# Use pacman for chromium instead of flatpak due to webapp manager
sudo pacman -S --noconfirm firefox chromium

yay -S --noconfirm google-chrome microsoft-edge-stable-bin

flatpak install -y flathub org.signal.Signal
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
# git config --global --replace-all credential.helper /usr/lib/git-core/git-credential-libsecret
yay -S --noconfirm git-credential-manager-core-bin
git config --global --replace-all credential.helper /usr/bin/git-credential-manager

yay -S --noconfirm github-desktop-bin
flatpak install -y flathub com.github.git_cola.git-cola 

# .NET Latest
yay -S --noconfirm dotnet-host-bin dotnet-runtime-bin dotnet-targeting-pack-bin dotnet-sdk-bin aspnet-runtime-bin aspnet-targeting-pack-bin

# .NET 6 LTS
yay -S --noconfirm dotnet-runtime-6.0-bin dotnet-targeting-pack-6.0-bin dotnet-sdk-6.0-bin aspnet-runtime-6.0-bin aspnet-targeting-pack-6.0-bin

# .NET Older
yay -S --noconfirm dotnet-runtime-2.2 dotnet-runtime-3.1
# yay -S --noconfirm dotnet-runtime-5.0-bin

# International Components for Unicode (ICU) 
sudo pacman -S --noconfirm icu

# Ensure latest International Components for Unicode (ICU) library is used by .NET
echo '' >> ~/.zshrc
echo '# Ensure .NET uses the latest ICU version' >> ~/.zshrc
echo 'export CLR_ICU_VERSION_OVERRIDE=$(icu-config --version)' >> ~/.zshrc

echo '' >> ~/.bashrc
echo '# Ensure .NET uses the latest ICU version' >> ~/.bashrc
echo 'export CLR_ICU_VERSION_OVERRIDE=$(icu-config --version)' >> ~/.bashrc

echo "######################################################################################################################"
echo "NOTE: YOU ALSO NEED TO EDIT THE PROPERTIES OF Visual Studio Code's code.desktop file in /usr/share/applications with CLR_ICU_VERSION_OVERRIDE=$(icu-config --version)"
echo "######################################################################################################################"

# PowerShell
yay -S --noconfirm powershell-bin

# Intel One Mono Font for developers - https://github.com/intel/intel-one-mono
yay -S --noconfirm woff-intel-one-mono otf-intel-one-mono ttf-intel-one-mono woff2-intel-one-mono

# VSCode - the official MS version is required (as opposed to OSS ‘code’) in order to be able to debug
yay -S --noconfirm visual-studio-code-bin
sudo pacman -S --noconfirm typescript eslint

# Postman
flatpak install -y flathub com.getpostman.Postman

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
# NOTE: This SHOULD now be replaced by git-credential-manager...
# https://github.com/microsoft/artifacts-credprovider#azure-artifacts-credential-provider
# Used indirectly with "dotnet restore --interactive"
# wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash

# Azure Tools (needs Python etc installed first)
yay -S --noconfirm azure-cli

yay -S --noconfirm azure-functions-core-tools-bin
yay -S --noconfirm storageexplorer
yay -S --noconfirm bicep-bin

# Database
yay -S --noconfirm azuredatastudio
sudo pacman -S --noconfirm dbeaver 
# NOTE: flatpak dbeaver cannot open system browser to connect to Azure SqlDb...


#########################
# A/V
#########################

# Spotify
# flatpak install -y flathub com.spotify.Client

# Deezer
# yay -S --noconfirm deezer

# Radio
flatpak install -y flathub com.github.louis77.tuner

# Jellyfin
flatpak install -y flathub com.github.iwalton3.jellyfin-media-player

# Video Players
flatpak install -y flathub org.videolan.VLC
flatpak install -y flathub org.bino3d.bino
flatpak install -y flathub io.mpv.Mpv

# Media Recording / Editing / Converting
flatpak install -y flathub net.mediaarea.MediaInfo
flatpak install -y flathub org.bunkus.mkvtoolnix-gui
flatpak install -y flathub org.nickvision.tagger
flatpak install -y flathub org.ardour.Ardour
flatpak install -y flathub org.kde.kdenlive
flatpak install -y flathub com.ozmartians.VidCutter
yay -S --noconfirm com.obsproject.Studio

# Camera / Photos
flatpak install -y flathub com.rawtherapee.RawTherapee
flatpak install -y flathub org.darktable.Darktable
flatpak install -y flathub org.entangle_photo.Manager 
flatpak install -y flathub org.kde.digikam

# Use your android device as a wireless/usb webcam
yay -S --noconfirm droidcam droidcam-obs-plugin

#########################
# Graphics
#########################
flatpak install -y flathub nl.hjdskes.gcolor3
flatpak install -y flathub org.kde.krita
flatpak install -y flathub org.inkscape.Inkscape
flatpak install -y flathub com.jgraph.drawio.desktop
flatpak install -y flathub page.codeberg.Imaginer.Imaginer

#########################
# Office
#########################
flatpak install -y flathub net.cozic.joplin_desktop
flatpak install -y flathub io.github.wereturtle.ghostwriter
flatpak install -y flathub org.onlyoffice.desktopeditors
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y flathub com.github.alainm23.planner