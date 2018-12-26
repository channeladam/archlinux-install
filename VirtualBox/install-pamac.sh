#!/bin/bash

echo "NOTE: THIS CANNOT BE RUN AS ROOT"

echo "pamac"
git clone https://aur.archlinux.org/pamac-aur.git ./pamac-tmp
cd ./pamac-tmp
makepkg -sic
cd ..
rm -rf ./pamac-tmp
