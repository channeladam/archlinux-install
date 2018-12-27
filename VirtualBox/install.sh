#!/bin/bash

#
# For more info, see https://wiki.archlinux.org/index.php/installation_guide
#

#############
# Partition disks with LVM
# Assuming a VirtualBox disk of size 100GB 
#############

echo "Creating filesystems"

sgdisk --zap-all

parted /dev/sda mktable gpt

# sgdisk --list-types
# gdisk's internal code ef02 is for BIOS boot partition - needed for Grub doing a BIOS/GPT configuration
sgdisk /dev/sda -n=1:0:+1M -t=1:ef02
#parted /dev/sda set 1 bios_grub on

# /dev/sda2 = /boot
sgdisk /dev/sda -n=2:0:+511M

# gdisk's internal code 8e00 is for Linux LVM
sgdisk /dev/sda -N=3 -t3:8e00


partprobe
mkfs.ext4 /dev/sda2


vgcreate ArchVG /dev/sda3

#swapsize=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
#swapsize=$(($swapsize/1000))"M"
#lvcreate -L $swapsize -n ArchSwap ArchVG
lvcreate -L 16G -n ArchSwap ArchVG
mkswap /dev/ArchVG/ArchSwap

lvcreate -L 30G -n ArchRoot ArchVG
mkfs.ext4 /dev/ArchVG/ArchRoot

lvcreate -l 100%FREE -n ArchHome ArchVG
mkfs.ext4 /dev/ArchVG/ArchHome


#############
# Update system clock
#############
echo "Updating system clock"
timedatectl set-ntp true

#############
# Mount everything
#############
echo "Mounting"
mount /dev/ArchVG/ArchRoot /mnt
mkdir /mnt/boot
mount /dev/sda2 /mnt/boot
mkdir /mnt/home
mount /dev/ArchVG/ArchHome /mnt/home
swapon /dev/ArchVG/ArchSwap


#############
# Install base packages
#############
pacman -Sy

#echo "installing base package with linux-lts"
#pacman -Sg base | cut -d ' ' -f 2 | sed s/\^linux\$/linux-lts/g | pacstrap /mnt - linux-lts-headers

echo "installing base package with latest linux"
pacstrap /mnt base

echo "installing other packages"
pacstrap /mnt base-devel parted gptfdisk iproute2


#############
# fstab
#############
echo "fstab"
genfstab -U -p /mnt >> /mnt/etc/fstab

# Important: Manually check and edit fstab if necessary
nano /mnt/etc/fstab
