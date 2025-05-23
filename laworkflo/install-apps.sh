#!/bin/bash

sudo pacman -Syu --noconfirm

########################
# Compilation tools
########################
sudo pacman -S --noconfirm ccache

#########################
# Disk tools
#########################

# NVMe disks, SSDs & SMART
sudo pacman -S --noconfirm nvme-cli smartmontools

# Periodic TRIM
sudo pacman -S --noconfirm util-linux
sudo systemctl enable --now fstrim.timer

# Auto-load the SCSI Generic Kernel Module
sudo echo sg > /etc/modules-load.d/sg.conf


#########################
# Application Managers
#########################
sudo pacman -S --noconfirm flatpak pamac-cli pamac-gtk pamac-flatpak-plugin
flatpak install -y flathub flatseal

# Portal support for flatpak
yay -S --noconfirm libportal-qt5 libportal-qt6 libportal-gtk3 libportal-gtk4

# App-Outlet AppImage https://app-outlet.github.io/
mkdir -p /home/adam/Applications/
export filename=$(curl -sI https://appoutlet.herokuapp.com/download/appimage | grep 'Location:' | sed -E 's/.*\/releases\/download\/v.*\/(\S*).*$/\1/')
curl -JLO https://appoutlet.herokuapp.com/download/appimage -o /home/adam/Applications/$filename
chmod +x ./$filename

# Downgrade
sudo pacman -S --noconfirm downgrade

# Make websites appear as their own apps - https://github.com/linuxmint/webapp-manager
# Use with Chromium, not FireFox! (buggy)
sudo pacman -S --noconfirm webapp-manager


#########################
# Networking / Firewall
#########################

# Network tools
pacman -S --noconfirm bind ldns iproute2 iputils iptables-nft

# Setup ufw / gufw as the local firewall

pacman -S --noconfirm ufw gufw

systemctl disable iptables
systemctl enable --now ufw

ufw default deny
ufw default allow outgoing

# Allow access from our local subnet
ufw allow from 192.168.0.0/24 comment 'Local network'

# Allow access for All Hosts Multicast Group on local network
# (e.g. used by Scream to receive)
ufw allow to 224.0.0.0/24 comment 'All Hosts Multicast Group'

ufw enable
ufw reload


# DNS Cache - systemd-resolved
systemctl enable --now systemd-resolved.service

# OpenResolve (which is compatible with NetworkManager - whereas systemd-resolvconf is not!)
# https://wiki.archlinux.org/title/NetworkManager#Use_openresolv
sudo pacman -S --noconfirm openresolv
sudo echo '[main]' >> /etc/NetworkManager/conf.d/rc-manager.conf
sudo echo 'rc-manager=resolvconf' >> /etc/NetworkManager/conf.d/rc-manager.conf

# Tell NetworkManager to ignore all wireguard devices
sudo echo '[keyfile]' >> /etc/NetworkManager/conf.d/unmanaged.conf
sudo echo 'unmanaged-devices=type:wireguard' >> /etc/NetworkManager/conf.d/unmanaged.conf

# Wireguard VPN
sudo pacman -S --noconfirm wireguard-tools


#########################
# Utilities
#########################

# Pipewire, WirePlumber
sudo pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack pipewire-v4l2 gst-plugin-pipewire wireplumber

# JamesDSP and easyeffects + Linux Studio Plugins (for Pipewire)
flatpak install -y flathub me.timschneeberger.jdsp4linux com.github.wwmm.easyeffects org.freedesktop.LinuxAudio.Plugins.LSP

# General Fonts
#  - gsfonts includes the 35 PostScript Level 2 Base Fonts, which provides alternatives for the Adobe standard/Base 14 fonts:
#     Courier, Courier-Bold, Courier-BoldOblique, Courier-Oblique,
#     Helvetica, Helvetica-Bold, Helvetica-BoldOblique, Helvetica-Oblique,
#     Symbol, Times-Bold, Times-BoldItalic, Times-Italic, Times-Roman, ZapfDingbats
#     See:
#      - https://en.wikipedia.org/wiki/PostScript_fonts#Core_Font_Set
#      - https://packages.debian.org/sid/fonts/fonts-urw-base35
#      - https://github.com/ArtifexSoftware/urw-base35-fonts/tree/master
sudo pacman -S --noconfirm gsfonts noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

# Font editing
sudo pacman -S --noconfirm fontforge

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

# Desktop Widgets (e.g. Color Picker)
sudo pacman -S --noconfirm kdeplasma-addons

# KVM - Input Leap - not currently available in the Flatpak repository as of 2024/12 version 3.0.2
# NOTE: The AUR version's server configuration would segfault on me...
echo
echo "##################################################################################################"
echo "Download input from https://github.com/input-leap/input-leap/releases"
echo "Then install: flatpak install -y ./[downloaded file - e.g. InputLeap_3.0.2_linux_x86_64.flatpak]"
echo "##################################################################################################"
echo

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

# Terminal - Tilix
sudo pacman -S --noconfirm tilix
echo '' >> ~/.bashrc
echo '# Tilix' >> ~/.bashrc
echo 'if [ $TILIX_ID ] || [ $VTE_VERSION ]; then' >> ~/.bashrc
echo '  source /etc/profile.d/vte.sh' >> ~/.bashrc
echo 'fi' >> ~/.bashrc

echo '' >> ~/.zshrc
echo '# Tilix' >> ~/.zshrc
echo 'if [ $TILIX_ID ] || [ $VTE_VERSION ]; then' >> ~/.zshrc
echo '  source /etc/profile.d/vte.sh' >> ~/.zshrc
echo 'fi' >> ~/.zshrc

# Hstr - History Search (activate with Ctrl-R) - https://github.com/dvorka/hstr
yay -S --noconfirm hstr
echo '' >> ~/.bashrc
hstr --show-bash-configuration >> ~/.bashrc
echo '' >> ~/.zshrc
hstr --show-zsh-configuration >> ~/.zshrc

# JSON
sudo pacman -S --noconfirm jq

# System Monitoring
sudo pacman -S --noconfirm xfce4-systemload-plugin bashtop stacer htop gnome-system-monitor
# https://missioncenter.io/
flatpak install -y flathub io.missioncenter.MissionCenter

# Diagnostics
sudo pacman -S --noconfirm strace

# Benchmarks
sudo pacman -S --noconfirm y-cruncher

# Calculator
flatpak install -y flathub org.gnome.Calculator

# Time tracking
flatpak install -y flathub org.kde.ktimetracker

# Downloading
flatpak install -y flathub org.qbittorrent.qBittorrent
flatpak install -y flathub org.nickvision.tubeconverter
flatpak install -y flathub io.freetubeapp.FreeTube
yay -S --noconfirm tartube

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

# Bottles / Wine
# NOTE: Run Bottles and configure winetricks -> winecfg -> Drives -> and add a T:\ pointing to /mnt/tdrive so that Wine apps can correctly see its free space!
# NOTE: Run Bottles, go into the preferences, and change the default folder to /mnt/data2
flatpak install -y flathub com.usebottles.bottles

#########################
# Internet & Communications
#########################

# Use pacman for vivaldi instead of flatpak due to keepass plugin
# sudo pacman -S --noconfirm vivaldi-bin vivaldi-ffmpeg-codecs

# Use pacman for Brave instead of flatpak due to keepass plugin
sudo pacman -S --noconfirm brave-browser
#flatpak install -y flathub com.brave.Browser

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
yay -S --noconfirm git-credential-manager-bin
git config --global --replace-all credential.helper /usr/bin/git-credential-manager

yay -S --noconfirm github-desktop-bin
flatpak install -y flathub com.github.git_cola.git-cola 
flatpak install -y flathub org.gitfourchette.gitfourchette

# .NET Latest
yay -S --noconfirm dotnet-host-bin dotnet-runtime-bin dotnet-targeting-pack-bin dotnet-sdk-bin aspnet-runtime-bin aspnet-targeting-pack-bin

# .NET 8 LTS
yay -S --noconfirm dotnet-runtime-8.0-bin dotnet-targeting-pack-8.0-bin dotnet-sdk-8.0-bin aspnet-runtime-8.0-bin aspnet-targeting-pack-8.0-bin

# .NET 7 - Expires May 2024
# yay -S --noconfirm dotnet-runtime-7.0-bin dotnet-targeting-pack-7.0-bin dotnet-sdk-7.0-bin aspnet-runtime-7.0-bin aspnet-targeting-pack-7.0-bin

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

# NOTE: YOU ALSO NEED TO EDIT THE PROPERTIES OF Visual Studio Code's code.desktop file in /usr/share/applications.
# This is because when VSCode is launched via a launcher (the .desktop file),
# it is not running from within a bash or zsh environment, and doesn't have that environment.
# Change Program to: /usr/bin/bash
# and Arguments to: -c 'CLR_ICU_VERSION_OVERRIDE=`icu-config --version` /usr/bin/code --unity-launch %F'
echo "######################################################################################################################"
echo "NOTE: YOU ALSO NEED TO EDIT THE PROPERTIES OF Visual Studio Code's code.desktop file in /usr/share/applications. Change Program to: /usr/bin/bash and Arguments to: -c 'CLR_ICU_VERSION_OVERRIDE=`icu-config --version` /usr/bin/code --unity-launch %F'"
echo "######################################################################################################################"

echo
echo "######################################################################################################################"
echo "NOTE: ALSO TURN OFF THE OPERATING SYSTEM'S FILE SEARCH INDEXING FOR YOUR ROOT SOURCE CODE FOLDER."
echo "######################################################################################################################"

# netcoredbg - https://github.com/Samsung/netcoredbg (allows debugging .NET Core apps in VSCode clones).
# yay -S --noconfirm netcoredbg

# PowerShell
yay -S --noconfirm powershell-bin

# Inter Font
sudo pacman -S --noconfirm inter-font

# Intel One Mono Font for developers - https://github.com/intel/intel-one-mono
yay -S --noconfirm woff-intel-one-mono otf-intel-one-mono ttf-intel-one-mono woff2-intel-one-mono

# Microsoft Cascadia Code font - https://github.com/microsoft/cascadia-code
sudo pacman -S --noconfirm ttf-cascadia-code otf-cascadia-code woff2-cascadia-code

# VSCode - the official MS version is required (as opposed to OSS ‘code’) in order to be able to debug
yay -S --noconfirm visual-studio-code-bin
sudo pacman -S --noconfirm typescript eslint

# Windsurf
# yay -S --noconfirm windsurf windsurf-marketplace
yay -S --noconfirm windsurf

# Coding Assistants - llama.cpp (use with twinny extension in VSCode)
#yay -S --noconfirm llama.cpp-git
# 16GB for basekit!
#sudo pacman -S --noconfirm intel-oneapi-basekit
# NOTE: see https://github.com/ggerganov/llama.cpp/blob/master/README-sycl.md :
#echo '' >> ~/.zshrc
#echo '# Initialise variables for Intel oneapi / SYCL' >> ~/.zshrc
#echo 'source /opt/intel/oneapi/setvars.sh' >> ~/.zshrc
#echo '' >> ~/.bashrc
#echo '# Initialise variables for Intel oneapi / SYCL' >> ~/.bashrc
#echo 'source /opt/intel/oneapi/setvars.sh' >> ~/.bashrc


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

# Podman
sudo pacman -S --noconfirm podman
yay -S --noconfirm podman-desktop-bin

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

# Reverse Engineering
# https://github.com/rizinorg/cutter
# flatpak install -y flathub re.rizin.cutter


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
# Problems with flatpak VLC playing videos, and VLC is required by other things anyway.
sudo pacman -S --noconfirm vlc
flatpak install -y flathub org.bino3d.bino
flatpak install -y flathub io.mpv.Mpv

# Media Recording / Editing / Converting
flatpak install -y flathub net.mediaarea.MediaInfo
flatpak install -y flathub org.bunkus.mkvtoolnix-gui
flatpak install -y flathub org.nickvision.tagger
flatpak install -y flathub org.ardour.Ardour
flatpak install -y flathub org.kde.kdenlive
flatpak install -y flathub io.github.jliljebl.Flowblade
flatpak install -y flathub com.ozmartians.VidCutter
yay -S --noconfirm com.obsproject.Studio

# Books
flatpak install -y flathub org.kde.arianna

# Camera / Photos
flatpak install -y flathub com.rawtherapee.RawTherapee
flatpak install -y flathub org.darktable.Darktable
flatpak install -y flathub org.entangle_photo.Manager 
flatpak install -y flathub org.kde.digikam

# Photogrammetry - https://github.com/Kitware/TeleSculptor
#flatpak install -y flathub org.telesculptor.TeleSculptor

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
flatpak install -y flathub org.upscayl.Upscayl
flatpak install -y flathub com.github.PintaProject.Pinta

# Image optimiser GUI
flatpak install -y flathub org.flozz.yoga-image-optimizer
# Image optimiser CLI
pip install yoga


#########################
# Office
#########################
flatpak install -y flathub net.cozic.joplin_desktop
flatpak install -y flathub io.github.wereturtle.ghostwriter
flatpak install -y flathub org.onlyoffice.desktopeditors
flatpak install -y flathub org.libreoffice.LibreOffice
# flatpak install -y flathub org.kde.calligra

#########################
# Project Management
#########################
# GanttProject https://www.ganttproject.biz/ https://github.com/bardsoftware/ganttproject
# ^ manual download
# sudo pacman -S --noconfirm calligra-plan
# sudo pacman -S --noconfirm planner
# yay -S --noconfirm projectlibre
# flatpak install -y flathub io.github.alainm23.planify


#########################
# Finance
#########################
flatpak install -y flathub info.portfolio_performance.PortfolioPerformance


#########################
# Data Analysis
#########################
flatpak install -y flathub org.kde.labplot2
flatpak install -y flathub org.jaspstats.JASP
flatpak install -y flathub org.squey.Squey  # https://squey.org


#########################
# Data Privacy
#########################
# Data Anonymization
# flatpak install -y flathub org.deidentifier.arx


#########################
# Languages & Grammar
#########################
# flatpak install -y flathub org.kde.kiten # Japanese
flatpak install -y flathub dev.mufeed.Wordbook  # https://github.com/mufeedali/Wordbook
flatpak install -y flathub io.github.quantum_mutnauq.fast_reader_gtk # Fast Reader


########################
# Medical
########################
# 3D medical imaging reconstruction software
# flatpak install -y flathub br.gov.cti.invesalius
# Blood Pressure
flatpak install -y flathub page.codeberg.lazyt.ubpm


#########################
# Other Utilities (that should be done at the end)
#########################

# Zoxide - https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
sudo pacman -S --noconfirm zoxide
# Zoxide config - Zsh
echo '' >> ~/.zshrc
echo '# NOTE: Ensure zoxide is the LAST line executed' >> ~/.zshrc
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
# Zoxide config - Bash
echo '' >> ~/.bashrc
echo '# NOTE: Ensure zoxide is the LAST line executed' >> ~/.bashrc
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
# Zoxide config - Powershell
mkdir -p ~/.config/powershell
echo '' >> ~/.config/powershell/Microsoft.PowerShell_profile.ps1
echo '# NOTE: Ensure zoxide is the LAST line executed' >> ~/.config/powershell/Microsoft.PowerShell_profile.ps1
echo 'Invoke-Expression (& { (zoxide init powershell | Out-String) })' >> ~/.config/powershell/Microsoft.PowerShell_profile.ps1