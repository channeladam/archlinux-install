#!/bin/bash

#############
# Setup a 500GB (465GB real) disk with encryption and LVM
#############

DEVICE_NAME=nvme0n1
DEVICE_PATH=/dev/$DEVICE_NAME
DEVICE_PARTITION_NAME_PREFIX=${DEVICE_NAME}p
DEVICE_PARTITION_PREFIX_PATH=/dev/$DEVICE_PARTITION_NAME_PREFIX

echo "Removing any existing partitions"
sgdisk -Z $DEVICE_PATH

echo "Creating GPT partition table"
parted $DEVICE_PATH mktable gpt

echo "Creating partitions"

## /dev/nvme0n1p1 = EFI System Partition (ESP)
## sgdisk --list-types
## gdisk's internal code ef00 is for EFI System - boot, esp
sgdisk $DEVICE_PATH -n=1:0:+512M -t=1:ef00

## /dev/nvme0n1p2 = Bootloader (e.g. GRUB) mounted at /boot
## gdisk internal code 8300 is for any linux file system
sgdisk $DEVICE_PATH -n=2:513M:+512M -t=2:8300

## /dev/nvme0n1p3 = Encrypted Partition
## gdisk's internal code 8309 is for Linux LUKS (encryption)
sgdisk $DEVICE_PATH -N=3 -t3:8309

partprobe

echo "Performing random wipe on partition to be encrypted."
echo "NOTE: a 256Gb disk will take ~20 minutes"
dd bs=10M status=progress if=/dev/urandom of=${DEVICE_PARTITION_PREFIX_PATH}3

echo "Creating file systems for ESP and Bootloader"
mkfs.vfat ${DEVICE_PARTITION_PREFIX_PATH}1 -n esp
mkfs.ext4 ${DEVICE_PARTITION_PREFIX_PATH}2 -L bootloader

echo "Creating LUKS container for encrypted partition."
echo "You will need to enter 'YES' and a passphrase."
cryptsetup luksFormat ${DEVICE_PARTITION_PREFIX_PATH}3
#Enter "YES"
#Enter passphrase

echo "Opening encrypted container."
echo "You will need to enter the passphrase."
# Becomes available at /dev/mapper/crypt-nvme0n1p3
cryptsetup luksOpen ${DEVICE_PARTITION_PREFIX_PATH}3 crypt-${DEVICE_PARTITION_NAME_PREFIX}3

# Using the LVM on LUKS approach.
# https://wiki.archlinux.org/index.php/Dm-crypt/Swap_encryption#LVM_on_LUKS
echo "Creating the LVM group and volumes within the encrypted container."
vgcreate ArchVG /dev/mapper/crypt-${DEVICE_PARTITION_NAME_PREFIX}3

#swapsize=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
#swapsize=$(($swapsize/1000))"M"
#lvcreate -L $swapsize -n ArchSwap ArchVG
lvcreate -L 42G -n ArchSwap ArchVG
mkswap /dev/ArchVG/ArchSwap

lvcreate -L 128G -n ArchRoot ArchVG
mkfs.ext4 /dev/ArchVG/ArchRoot

#lvcreate -l 100%FREE -n ArchHome ArchVG
# NOTE: We want to leave space for snapshots, so do not use 100% of the Volume Group
# With 200G for home on a 500G disk, there will be ~90G remaining for snapshots
lvcreate -L 200G -n ArchHome ArchVG
mkfs.ext4 /dev/ArchVG/ArchHome

echo "This is how it looks:"
sgdisk -p $DEVICE_PATH
lsblk
lvdisplay
