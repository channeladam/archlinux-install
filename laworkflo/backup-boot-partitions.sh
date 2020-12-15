#!/bin/bash

# Variables
DEVICE_NAME=nvme0n1
DEVICE_PARTITION_NAME_PREFIX=${DEVICE_NAME}p
DEVICE_PATH=/dev/$DEVICE_NAME
DEVICE_PARTITION_PREFIX_PATH=/dev/$DEVICE_PARTITION_NAME_PREFIX
DATE=$(date +%Y%m%d)

BACKUP_PATH=/mnt/Backups/Partitions
mkdir -p $BACKUP_PATH

# Backup the EFI System Partition (ESP)
echo "##### Unmounting /boot/efi"
sudo umount /boot/efi

echo "##### Backing up EFI System Partition"
sudo partclone.fat32 -c -s ${DEVICE_PARTITION_PREFIX_PATH}1 -O "${BACKUP_PATH}/${DATE}-${DEVICE_PARTITION_NAME_PREFIX}1-esp.pcimg"

# Backup Bootloader Partition
echo "##### Unmounting /boot"
sudo umount /boot

echo "##### Backing up Bootloader Partition"
sudo partclone.ext4 -c -s ${DEVICE_PARTITION_PREFIX_PATH}2 -O "${BACKUP_PATH}/${DATE}-${DEVICE_PARTITION_NAME_PREFIX}2-bootloader.pcimg"

# Remount all filesystems in fstab
echo "##### Remounting all filesystems"
sudo mount --all