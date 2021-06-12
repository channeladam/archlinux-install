# Remove conflicting XFCE files
sudo mv /etc/skel/.xinitrc /etc/skel/.xinitrc.xfce

# Update package databases
sudo pacman -Sy

# Install base KDE
sudo pacman -S --noconfirm sddm plasma kio-extras
sudo systemctl disable lightdm.service
sudo systemctl enable sddm.service --force

# Remove XFCE4
sudo pacman -Ruc xfce4 xfce4-goodies xfce4-systemload-plugin manjaro-settings-manager-notifier manjaro-xfce-minimal-settings tilix redshift lightdm lightdm-gtk-greeter

# Install KDE settings and themes
sudo pacman -S --noconfirm manjaro-kde-settings sddm-breath-theme manjaro-settings-manager-knotifier manjaro-settings-manager-kcm breath2-icon-themes breath2-wallpaper plasma5-themes-breath2 sddm-breath2-theme materia-kde kvantum-theme-materia

# Install KDE utilities
sudo pacman -S --noconfirm kde-system-meta kde-utilities-meta dolphin-plugins krusader kompare krename
flatpak install -y flathub org.gnome.meld
flatpak install -y flathub org.flameshot.Flameshot

# Install replacement for dog slow Icon-Only Task Manager panel widget
sudo pacman -S --noconfirm latte-dock

# Install KDE apps
sudo pacman -S --noconfirm kdeconnect krdc

# Update user group
echo "TODO: Run the command below to update the user's groups"
echo "sudo usermod -a -G lp,network,power,sys,wheel <username>"

# Reboot
echo "TODO: Reboot"
echo "sudo systemctl reboot"
