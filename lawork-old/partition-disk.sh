#!/bin/bash

#############
# Setup disk with encryption and LVM
#############

echo "Creating GPT partition table"
parted /dev/sda mktable gpt

echo "Creating partitions"

## /dev/sda1 = EFI System Partition (ESP)
## sgdisk --list-types
## gdisk's internal code ef00 is for EFI System - boot, esp
sgdisk /dev/sda -n=1:0:+200M -t=1:ef00

## /dev/sda2 = Bootloader (e.g. GRUB) mounted at /boot
## gdisk internal code 8300 is for any linux file system
sgdisk /dev/sda -n=2:201M:+312M -t=2:8300

## /dev/sda3 = Encrypted Partition
## gdisk's internal code 8309 is for Linux LUKS (encryption)
sgdisk /dev/sda -N=3 -t3:8e00

partprobe

echo "Performing random wipe on partition to be encrypted."
echo "NOTE: a 256Gb disk will take ~20 minutes"
dd bs=10M status=progress if=/dev/urandom of=/dev/sda3

echo "Creating file systems for ESP and Bootloader"
mkfs.vfat /dev/sda1 -L esp
mkfs.ext4 /dev/sda2 -L bootloader

echo "Creating LUKS container for encrypted partition."
echo "You will need to enter 'YES' and a passphrase."
cryptsetup luksFormat /dev/sda3
#Enter "YES"
#Enter passphrase

echo "Opening encrypted container."
echo "You will need to enter the passphrase."
# Becomes available at /dev/mapper/crypt-sda3
cryptsetup luksOpen /dev/sda3 crypt-sda3

echo "Creating the LVM group and volumes within the encrypted container."
vgcreate ArchVG /dev/mapper/crypt-sda3

#swapsize=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
#swapsize=$(($swapsize/1000))"M"
#lvcreate -L $swapsize -n ArchSwap ArchVG
lvcreate -L 40G -n ArchSwap ArchVG
mkswap /dev/ArchVG/ArchSwap

lvcreate -L 80G -n ArchRoot ArchVG
mkfs.ext4 /dev/ArchVG/ArchRoot

#lvcreate -l 100%FREE -n ArchHome ArchVG
lvcreate -L 100G -n ArchHome ArchVG
mkfs.ext4 /dev/ArchVG/ArchHome

echo "This is how it looks:"
sgdisk -p /dev/sda
lsblk
lvdisplay
