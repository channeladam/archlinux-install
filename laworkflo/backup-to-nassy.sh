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
echo "Backing up LUKS-headers"
rsync -aPh /mnt/Backups/LUKS-headers/ $BACKUP_ROOT/LUKS-headers

echo "Backing up Partitions"
rsync -aPh /mnt/Backups/Partitions/ $BACKUP_ROOT/Partitions

echo "Backing up .config"
rsync -aPh \
--exclude azuredatastudio/ \
--exclude Code/ \
--exclude Cache/ \
--exclude cache/ \
--exclude logs/ \
/home/adam/.config/ $BACKUP_ROOT/adam/.config

echo "Backing up .local"
rsync -aPh \
--exclude share/Trash \
/home/adam/.local/ $BACKUP_ROOT/adam/.local

echo "Backing up .thunderbird"
rsync -aPh /home/adam/.thunderbird/ $BACKUP_ROOT/adam/.thunderbird

echo "Backing up davmail.properties"
rsync -aPh /home/adam/.davmail.properties $BACKUP_ROOT/adam/.davmail.properties

echo "Backing up Documents"
rsync -aPh \
--exclude .git/ \
--exclude obj/ \
--exclude bin/ \
--exclude node_modules/ \
--exclude **/*.log \
--exclude **/*.bak \
--exclude **/*.ldf \
--exclude **/*.mdf \
--exclude **/*.ndf \
/home/adam/Documents/ $BACKUP_ROOT/adam/Documents

echo "Backing up scripts"
rsync -aPh /home/adam/scripts/ $BACKUP_ROOT/adam/scripts

echo "Backing up repos"
rsync -aPh \
--exclude .git/ \
--exclude obj/ \
--exclude bin/ \
--exclude node_modules/ \
--exclude **/*.log \
--exclude **/*.bak \
--exclude **/*.ldf \
--exclude **/*.mdf \
--exclude **/*.ndf \
/home/adam/repos/ $BACKUP_ROOT/adam/repos 

echo "Umounting"
sudo umount /mnt/3copynassy

echo "Finished!"
