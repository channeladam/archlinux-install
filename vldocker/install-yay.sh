
#!/bin/bash

echo "NOTE: THIS CANNOT BE RUN AS ROOT"

echo "yay"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si