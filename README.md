# archlinux-install
My install script for Arch Linux.

WARNING: Do NOT run this without understanding every part of the script, all associated risks and the DATA LOSS that WILL occur.

## Step 1 - Boot into Arch Linux
Download ISO from https://www.archlinux.org/download/ and boot into a VirtualBox VM.

## Step 2 - Download these scripts
At the Arch Linux install console:
``` bash
# wget https://github.com/channeladam/archlinux-install/archive/master.zip
# pacman -Sy unzip
# unzip master
# cd archlinux-install-master/VirtualBox
# chmod +x *.sh
```

## Step 3 - Run install.sh
``` bash
# ./install.sh
```

## Step 4 - Run configure.sh
``` bash
# ./configure.sh
```
