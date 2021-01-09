#!/bin/sh

echo "Mounting 3CopyNassy"
sudo mount.smb3 //192.168.0.100/3CopyNassy /mnt/3copynassy -o uid=adam,gid=adam,username=adam

BACKUP_ROOT=/mnt/3copynassy/2CopyNassy/DriveBackups/LWorkFlo
mkdir -p $BACKUP_ROOT

# Fix any permissions
echo "Fixing backup image permissions"
sudo setfacl -R -m u::rwx,g::rwx,o::-,default:u::rwx,default:g::rwx,default:o::- /mnt/Backups/LUKS-headers
sudo setfacl -R -m u::rwx,g::rwx,o::-,default:u::rwx,default:g::rwx,default:o::- /mnt/Backups/Partitions
sudo chgrp -R adam /mnt/Backups/LUKS-headers
sudo chgrp -R adam /mnt/Backups/Partitions

# Backup
echo "Backing up"
rsync -aPh /mnt/Backups/LUKS-headers/ $BACKUP_ROOT/LUKS-headers
rsync -aPh /mnt/Backups/Partitions/ $BACKUP_ROOT/Partitions

rsync -aPh /home/adam/Documents/ $BACKUP_ROOT/adam/Documents
rsync -aPh /home/adam/scripts/ $BACKUP_ROOT/adam/scripts
rsync -aPh /home/adam/repos/ $BACKUP_ROOT/adam/repos
rsync -aPh /home/adam/.config/ $BACKUP_ROOT/adam/.config
rsync -aPh /home/adam/.local/ $BACKUP_ROOT/adam/.local
rsync -aPh /home/adam/.thunderbird/ $BACKUP_ROOT/adam/.thunderbird
rsync -aPh /home/adam/.davmail.properties $BACKUP_ROOT/adam/.davmail.properties

echo "Umounting"
sudo umount /mnt/3copynassy

echo "Finished!"
