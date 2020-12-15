#!/bin/bash
#
# See:
# https://wiki.archlinux.org/index.php/disk_encryption#LUKS_header_backup
# https://wiki.archlinux.org/index.php/Dm-crypt/Device_encryption#Backup_and_restore

# Variables
DISK1_DEVICE_PARTITION_NAME=nvme0n1p3
DISK1_DEVICE_PARTITION_PATH=/dev/$DISK1_DEVICE_PARTITION_NAME
DISK2_DEVICE_PARTITION_NAME=nvme1n1p1
DISK2_DEVICE_PARTITION_PATH=/dev/$DISK2_DEVICE_PARTITION_NAME
DATE=$(date +%Y%m%d)

BACKUP_PATH=/mnt/Backups/LUKS-headers
mkdir -p $BACKUP_PATH

# Backup the LUKS header for Disk 1
echo "##### Backing up LUKS header for Disk 1 Partition"
sudo cryptsetup luksHeaderBackup $DISK1_DEVICE_PARTITION_PATH --header-backup-file ${BACKUP_PATH}/${DATE}-${DISK1_DEVICE_PARTITION_NAME}-luks-header-backup.img

echo "##### Backing up LUKS header for Disk 2 Partition"
sudo cryptsetup luksHeaderBackup $DISK2_DEVICE_PARTITION_PATH --header-backup-file ${BACKUP_PATH}/${DATE}-${DISK2_DEVICE_PARTITION_NAME}-luks-header-backup.img
