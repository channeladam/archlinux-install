#!/bin/bash

#############
# Usage: Run this as root or use sudo.
#
# Setup for a Proxmox VM to act as a worker.
#  Note: the EFI disk is separate.
#  80GB disk, LVM, not encrypted.
#############

DEVICE_NAME=sda
DEVICE_PATH=/dev/$DEVICE_NAME
DEVICE_PARTITION_NAME_PREFIX=${DEVICE_NAME}
DEVICE_PARTITION_PREFIX_PATH=/dev/$DEVICE_PARTITION_NAME_PREFIX

# Install tools for disks
pacman -Sy gptfdisk parted e2fsprogs dosfstools

echo "Removing any existing partitions"
sgdisk -Z $DEVICE_PATH

echo "Creating GPT partition table"
parted $DEVICE_PATH mktable gpt

echo "Creating partitions"

## /dev/sda1 = Bootloader (e.g. GRUB) mounted at /boot
## gdisk internal code 8300 is for any linux file system
sgdisk $DEVICE_PATH -n=1:0:+512M -t=1:8300

## /dev/sda2 = Encrypted Partition
## gdisk's internal code 8309 is for Linux LUKS (encryption)
sgdisk $DEVICE_PATH -N=2 -t2:8e00

partprobe

echo "Creating file system for Bootloader"
mkfs.ext4 ${DEVICE_PARTITION_PREFIX_PATH}1 -L bootloader

# Using the LVM on LUKS approach.
# https://wiki.archlinux.org/index.php/Dm-crypt/Swap_encryption#LVM_on_LUKS
echo "Creating the LVM group and volumes within the encrypted container."
vgcreate ArchVG ${DEVICE_PATH}2

# No swap for a worker

# ArchRoot
lvcreate -L 70G -n ArchRoot ArchVG
mkfs.ext4 /dev/ArchVG/ArchRoot

#lvcreate -l 100%FREE -n ArchHome ArchVG
# NOTE: We want to leave space for snapshots, so do not use 100% of the Volume Group
# With 5G for home on a 80G disk, there will be ~5G remaining for snapshots
lvcreate -L 5G -n ArchHome ArchVG
mkfs.ext4 /dev/ArchVG/ArchHome

echo "This is how it looks:"
sgdisk -p $DEVICE_PATH
lsblk
lvdisplay
