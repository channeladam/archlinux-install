#!/bin/bash

#############
# Setup a 500GB (465GB real) disk with encryption and LVM
#############

echo "Removing any existing partitions"
sgdisk -Z /dev/nvme0n1

echo "Creating GPT partition table"
parted /dev/nvme0n1 mktable gpt

echo "Creating partitions"

## /dev/nvme0n1p1 = EFI System Partition (ESP)
## sgdisk --list-types
## gdisk's internal code ef00 is for EFI System - boot, esp
sgdisk /dev/nvme0n1 -n=1:0:+512M -t=1:ef00

## /dev/nvme0n1p2 = Bootloader (e.g. GRUB) mounted at /boot
## gdisk internal code 8300 is for any linux file system
sgdisk /dev/nvme0n1 -n=2:513M:+512M -t=2:8300

## /dev/nvme0n1p3 = Encrypted Partition
## gdisk's internal code 8309 is for Linux LUKS (encryption)
sgdisk /dev/nvme0n1 -N=3 -t3:8e00

partprobe

echo "Performing random wipe on partition to be encrypted."
echo "NOTE: a 256Gb disk will take ~20 minutes"
dd bs=10M status=progress if=/dev/urandom of=/dev/nvme0n1p3

echo "Creating file systems for ESP and Bootloader"
mkfs.vfat /dev/nvme0n1p1 -L esp
mkfs.ext4 /dev/nvme0n1p2 -L bootloader

echo "Creating LUKS container for encrypted partition."
echo "You will need to enter 'YES' and a passphrase."
cryptsetup luksFormat /dev/nvme0n1p3
#Enter "YES"
#Enter passphrase

echo "Opening encrypted container."
echo "You will need to enter the passphrase."
# Becomes available at /dev/mapper/crypt-nvme0n1p3
cryptsetup luksOpen /dev/nvme0n1p3 crypt-nvme0n1p3

echo "Creating the LVM group and volumes within the encrypted container."
vgcreate ArchVG /dev/mapper/crypt-nvme0n1p3

#swapsize=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
#swapsize=$(($swapsize/1000))"M"
#lvcreate -L $swapsize -n ArchSwap ArchVG
lvcreate -L 42G -n ArchSwap ArchVG
mkswap /dev/ArchVG/ArchSwap

lvcreate -L 128G -n ArchRoot ArchVG
mkfs.ext4 /dev/ArchVG/ArchRoot

lvcreate -l 100%FREE -n ArchHome ArchVG
#lvcreate -L 286G -n ArchHome ArchVG
mkfs.ext4 /dev/ArchVG/ArchHome

echo "This is how it looks:"
sgdisk -p /dev/nvme0n1
lsblk
lvdisplay
