# archlinux-install
My install script for Arch Linux.

WARNING: Do NOT run this without understanding every part of the script, all associated risks and the DATA LOSS that WILL occur.

## Step 1 - Create a VM
In VirtualBox, create a VM named "Arch Linux"

## Step 2 - Set custom VESA resolutions
Run the script configure-windows-host.cmd to set custom VESA resolutions for the VM.

## Step 3 - Boot into the Arch Linux VM
Download ISO from https://www.archlinux.org/download/ and boot into the  VirtualBox VM.

## Step 4 - Download these scripts into the VM
At the Arch Linux install console:
``` bash
# wget https://github.com/channeladam/archlinux-install/archive/master.zip
# pacman -Sy unzip
# unzip master
# cd archlinux-install-master/VirtualBox
# chmod +x *.sh
```

## Step 5 - Run install.sh
``` bash
# ./install.sh
```

## Step 6 - Run configure.sh
``` bash
# ./configure.sh
```

## Step 7 - Run install-kde.sh or install-xfce.sh
``` bash
# arch-chroot /mnt /bin/bash install-kde.sh
or
# arch-chroot /mnt /bin/bash install-xfce.sh
```

## Step 8 - Run install-pamac.sh
``` bash
# arch-chroot /mnt /bin/bash
# sudo -u adam bash
$ ./install-pamac.sh
$ exit
```

## Step 9 - Run install-apps.sh
``` bash
# arch-chroot /mnt /bin/bash
# ./install-apps.sh
# exit
```

## Step 10 - Reboot into KDE
Dismount the ISO and reboot.
Login as a non-root user
