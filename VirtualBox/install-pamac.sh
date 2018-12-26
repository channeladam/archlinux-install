#!/bin/bash

echo "NOTE: THIS CANNOT BE RUN AS ROOT"

echo "package manager - pamac"
git clone https://aur.archlinux.org/pamac-aur.git ./pamac-tmp
cd ./pamac-tmp
makepkg -sic
cd ..
rm -rf ./pamac-tmp
echo "*** Ensure you turn on AUR in the pamac preferences ***"
