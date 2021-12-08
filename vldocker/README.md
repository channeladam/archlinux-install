# VirtualBox
My install script for Arch Linux in a Proxmox VM.

WARNING: Do NOT run this without understanding every part of the script, all associated risks and the DATA LOSS that WILL occur.

## Step 1 - Create a VM
In Proxmox, create a VM

## Step 2 - Boot into the Arch Linux VM
Download ISO from https://www.archlinux.org/download/ and boot into the VM.

## Step 3 - Download these scripts into the VM
At the Arch Linux install console:
``` bash
# wget https://github.com/channeladam/archlinux-install/archive/master.zip
# pacman -Sy unzip
# unzip master
# cd archlinux-install-master/vldocker
# chmod +x *.sh
```

## Step 4 - Run install.sh
``` bash
# ./install.sh
```

## Step 5 - Run configure.sh
``` bash
# ./configure.sh
```

## Step 6 - Run install-pamac.sh
``` bash
# arch-chroot /mnt
# sudo -u adam bash
$ ./install-pamac.sh
$ exit
```

## Step 7 - Run install-apps.sh
``` bash
# arch-chroot /mnt
# ./install-apps.sh
# exit
```

## Step 8 - Reboot
Dismount the ISO and reboot.
Login as a non-root user
