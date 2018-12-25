#!/bin/bash

#############
# Configure
#############

# timezone
echo "timezone"
ln -sf /usr/share/zoneinfo/Australia/Brisbane /etc/localtime

# generate /etc/adjtime, assuming UTC hardware clock
echo "hardware clock"
hwclock --systohc

# localisation
echo "localisation"
locale-gen

locale="en_AU"
# echo "LANG=en_AU.UTF-8" > /etc/locale.conf
echo "LANG=$locale.UTF-8" > /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf

# comment out all other locales from locale.gen
# sed -i '/'en_AU'.UTF-8/s/^#//g' /etc/locale.gen
sed -i '/'$locale'.UTF-8/s/^#//g' /etc/locale.gen

# hostname
echo "hostname"
hostname="VLArch"
# echo "VLArch" > /etc/hostname
echo "$hostname" > /etc/hostname

# hosts
echo "hosts"
echo "127.0.0.1    localhost" > /etc/hosts
echo "::1          localhost" >> /etc/hosts
echo "127.0.1.1    VLArch.localdomain    VLArch" >> /etc/hosts

# Initramfs
echo "initramfs"
mkinitcpio -p linux

# Root password
echo "root password"
passwd

# Microcode (do this before bootloader)
echo "microcode"
pacman -S intel-ucode

# Bootloader
echo "bootloader"
pacstrap /mnt grub
#pacman -S grub
grub-install --target=i386-pc --recheck -v /dev/sda

mkdir /boot/grub
grub-mkconfig -o /boot/grub/grub.cfg



echo "done"

# umount -R /mnt
# reboot
