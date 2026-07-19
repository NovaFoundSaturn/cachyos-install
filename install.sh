#!/usr/bin/env fish

# A simple shell script to install my dotfiles and setup some basics for my system.

set pkgs \
niri \
noctalia \
sddm \
nautilus \
ghostty \
ghostty-nautilus \
zen-browser-bin \
github-cli \
github-desktop \
gnome-disk-utility \
adw-gtk-theme \
brightnessctl \
capitaine-cursors \
xwayland-satellite \
cachyos-gaming-meta \
steam \
discord \
helix \
libreoffice-fresh \
gnome-calculator \
proton-vpn-gtk-app 
###!!! THERE IS CURRENTLY SOMETHING IN THE CACHYOS NOCTALIA NIRI PACKAGE THAT FIXES DISCORD STREAMING, Idk what does it exactly

git clone https://github.com/NovaFoundSaturn/dotfiles.git

mkdir ~/Projects
mkdir ~/Pictures
rm ~/.config/fish/config.fish

mv ./dotfiles ~/Projects/

ln -s ~/Projects/dotfiles/.vimrc ~/
ln -s ~/Projects/dotfiles/fastfetch ~/.config
ln -s ~/Projects/dotfiles/niri ~/.config
ln -s ~/Projects/dotfiles/noctalia ~/.config
ln -s ~/Projects/dotfiles/fish/config.fish ~/.config/fish/
ln -s ~/Projects/dotfiles/ghostty ~/.config
ln -s ~/Projects/dotfiles/wallpapers ~/Pictures/Wallpapers
ln -s ~/Projects/dotfiles/helix ~/.config/

# Update and Install new packages
sudo pacman -Syu $pkgs

# Enable display manager
sudo systemctl enable sddm
