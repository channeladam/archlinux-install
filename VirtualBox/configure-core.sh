#!/bin/bash
#############
echo "Final setup to fix LVM in CHROOT"
ln -s /hostlvm /run/lvm

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

# uncomment our locale in locale.gen
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

# DHCP
echo "enable DHCP"
WIRED_DEV=`ip link | grep "ens\|eno\|enp" | awk '{print $2}'| sed 's/://' | sed '1!d'`
if [[ -n $WIRED_DEV ]]; then
  systemctl enable dhcpcd@${WIRED_DEV}.service
fi

# Initramfs
echo "initramfs"
echo 'enabling LVM in mkinitcpio.conf'
sed -i '/^HOOK/s/filesystems/lvm2 filesystems/' /etc/mkinitcpio.conf
#mkinitcpio -p linux-lts
mkinitcpio -p linux

# Root password
echo "Change root password"
passwd

# User
echo "Add user and change password"
useradd --home-dir /home/adam --create-home -G wheel,uucp,video,audio,storage,games,input adam
passwd adam

# Sudoers
echo "Adding wheel group to /etc/sudoers"
echo "%wheel ALL=(ALL) ALL" | (EDITOR="tee -a" visudo)

# No need for microcode in a VM ;)
# Microcode (do this before bootloader)
#echo "microcode"
#pacman -S intel-ucode

# Bootloader
echo "install bootloader"
pacman -S grub
grub-install --target=i386-pc --recheck -v /dev/sda

echo "enable lvm in grub"
sed -i '/^GRUB_PRELOAD_MODULES/s/part_msdos\"/part_msdos lvm\"/' /etc/default/grub

echo "generate grub config file"
mkdir /boot/grub
grub-mkconfig -o /boot/grub/grub.cfg

############
echo "Cleaning up LVM"
unlink /run/lvm

############
echo "done"
