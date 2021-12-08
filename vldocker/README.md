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
# curl -L https://github.com/channeladam/archlinux-install/archive/master.zip --output master.zip
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

## Step 6 - Run install-yay.sh
``` bash
# arch-chroot /mnt
# sudo -u adam bash
$ ./install-yay.sh
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


## Step 9 - Install Portainer

https://docs.portainer.io/v/ce-2.9/start/install/server/docker/linux

```
docker volume create portainer_data

docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    cr.portainer.io/portainer/portainer-ce:latest

docker ps
```

Login to Portainer at https://<ip address>:9443 to set the admin password