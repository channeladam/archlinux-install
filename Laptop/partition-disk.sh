#!/bin/bash

#############
# Partition disks with LVM
# Assuming a SSD disk of size 256GB 
#############

echo "Creating filesystems"


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
lvcreate -L 40G -n ArchSwap ArchVG
mkswap /dev/ArchVG/ArchSwap

lvcreate -L 80G -n ArchRoot ArchVG
mkfs.ext4 /dev/ArchVG/ArchRoot

lvcreate -l 100%FREE -n ArchHome ArchVG
mkfs.ext4 /dev/ArchVG/ArchHome
