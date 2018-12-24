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
# Chroot
#############
arch-chroot /mnt
