#!/bin/bash

#############
# Partition disks with LVM
# Assuming a SSD disk of size 256GB 
#############

echo "Creating filesystems"


parted /dev/sda mktable gpt

# /dev/sda1 = /boot (EFI System)
# sgdisk --list-types
# gdisk's internal code ef00 is for EFI System - boot, esp
sgdisk /dev/sda -n=1:0:+512M -t=1:ef00

# gdisk's internal code 8e00 is for Linux LVM
sgdisk /dev/sda -N=2 -t2:8e00


partprobe
mkfs.vfat /dev/sda1


vgcreate ArchVG /dev/sda2

#swapsize=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
#swapsize=$(($swapsize/1000))"M"
#lvcreate -L $swapsize -n ArchSwap ArchVG
lvcreate -L 40G -n ArchSwap ArchVG
mkswap /dev/ArchVG/ArchSwap

lvcreate -L 80G -n ArchRoot ArchVG
mkfs.ext4 /dev/ArchVG/ArchRoot

lvcreate -l 100%FREE -n ArchHome ArchVG
mkfs.ext4 /dev/ArchVG/ArchHome
