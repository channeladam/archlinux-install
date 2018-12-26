#!/bin/bash

echo "NOTE: This must be run AFTER install-pamac.sh"

echo "AUR package manager - pikaur"
pamac build pikaur

echo "system updater tray icon"
#echo "pamac-tray-appindicator"
#pikaur -S pamac-tray-appindicator
echo "kalu"
pikaur -S kalu

echo "apps"
pacman -S chromium firefox code nodejs docker
