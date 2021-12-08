#!/bin/bash

#
# For more info, see https://wiki.archlinux.org/index.php/installation_guide
#

#############
# Mount everything
#############
echo "Mounting"
mount /dev/ArchVG/ArchRoot /mnt
mkdir /mnt/boot
mount /dev/sda2 /mnt/boot
mkdir /mnt/home
mount /dev/ArchVG/ArchHome /mnt/home
swapon /dev/ArchVG/ArchSwap

#############
# Fix LVM issue 
# https://bbs.archlinux.org/viewtopic.php?pid=1820949#p1820949
# vgscan -v gives error:
#   WARNING: Failed to connect to lvmetad. Falling back to device scanning.
#   Reading all physical volumes. This may take a while...
#   WARNING: Device /dev/loop0 not initialized in udev database even after waiting 10000000 microseconds.
# This happens because the hosts /run directory is not available within chroot.
#############
echo "Fixing LVM issue"
mkdir /mnt/hostlvm
mount --bind /run/lvm /mnt/hostlvm

#############
# Run configure-core.sh in chroot
#############
echo "Running configure-core.sh in CHROOT"
cp configure-core.sh /mnt
arch-chroot /mnt /bin/bash configure-core.sh

#############
# Clean up
#############
echo "Cleaning up"
umount /mnt/hostlvm
rmdir /mnt/hostlvm
rm /mnt/configure-core.sh

echo "Finished configuration"

# umount -R /mnt
# reboot
