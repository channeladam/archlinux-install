#!/bin/bash

#############
# Setup a 1TB (465*2 GB real) disk with encryption and LVM
#############

DEVICE_NAME=nvme1n1
DEVICE_PATH=/dev/$DEVICE_NAME
DEVICE_PARTITION_NAME_PREFIX=${DEVICE_NAME}p
DEVICE_PARTITION_PREFIX_PATH=/dev/$DEVICE_PARTITION_NAME_PREFIX

echo "Removing any existing partitions"
sgdisk -Z $DEVICE_PATH

echo "Creating GPT partition table"
parted $DEVICE_PATH mktable gpt

echo "Creating partitions"
## gdisk's internal code 8309 is for Linux LUKS (encryption)
sgdisk $DEVICE_PATH -N=1 -t1:8309 
partprobe
dd bs=100M status=progress if=/dev/urandom of=$DEVICE_PARTITION_PREFIX_PATH

cryptsetup luksFormat ${DEVICE_PARTITION_PREFIX_PATH}1
cryptsetup luksOpen ${DEVICE_PARTITION_PREFIX_PATH}1 crypt-${DEVICE_PARTITION_NAME_PREFIX}1

# Using the LVM on LUKS approach.
# https://wiki.archlinux.org/index.php/Dm-crypt/Swap_encryption#LVM_on_LUKS
echo "Creating the LVM group and volumes within the encrypted container."
vgcreate Disk2VG /dev/mapper/crypt-${DEVICE_PARTITION_NAME_PREFIX}1

lvcreate -L 465G -n VirtualMachines Disk2VG
mkfs.ext4 /dev/Disk2VG/VirtualMachines

lvcreate -l 100%FREE -n Backups Disk2VG
mkfs.ext4 /dev/Disk2VG/Backups

echo "This is how it looks:"
sgdisk -p $DEVICE_PATH
lsblk
lvdisplay

# mount -o rw,noatime /dev/mapper/Disk2VG-VirtualMachines /mnt/VirtualMachines
# mount -o rw,relatime /dev/mapper/Disk2VG-Backups /mnt/Backups
#
# umount /mnt/Backups
# umount /mnt/VirtualMachines
# vgchange -an Disk2VG
# cryptsetup luksClose crypt-${DEVICE_PARTITION_NAME_PREFIX}1
