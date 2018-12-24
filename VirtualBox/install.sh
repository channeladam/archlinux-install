#!/bin/bash

#
# For more info, see https://wiki.archlinux.org/index.php/installation_guide
#

#############
# Partition disks with LVM
# Assuming a VirtualBox disk of size 100GB 
#############

sgdisk --zap-all

parted /dev/sda mktable gpt

# sgdisk --list-types
# gdisk's internal code ef02 is for BIOS boot partition
sgdisk /dev/sda -n=1:0:+511M
parted /dev/sda set 1 boot on

# gdisk's internal code 8e00 is for Linux LVM
sgdisk /dev/sda -N=2 -t2:8e00

vgcreate ArchVG /dev/sda2

swapsize=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
swapsize=$(($swapsize/1000))"M"
# sgdisk $device -n=3:0:+$swapsize -t=3:8200
lvcreate -L $swapsize -n ArchSwap ArchVG
#lvcreate -L 16G -n ArchSwap ArchVG
mkswap /dev/ArchVG/ArchSwap

lvcreate -L 30G -n ArchRoot ArchVG
mkfs.ext4 /dev/ArchVG/ArchRoot

lvcreate -l 100%FREE -n ArchHome ArchVG
mkfs.ext4 /dev/ArchVG/ArchHome


#############
# Update system clock
#############
timedatectl set-ntp true

#############
# Mount everything
#############
mount /dev/ArchVG/ArchRoot /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir /mnt/home
mount /dev/ArchVG/ArchHome /mnt/home
swapon /dev/ArchVG/ArchSwap

#############
# Install base packages
#############
pacstrap /mnt base

#############
# Configure
#############

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# chroot
arch-chroot /mnt

# timezone
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime

# generate /etc/adjtime, assuming UTC hardware clock
hwclock --systohc

# localisation
locale-gen
