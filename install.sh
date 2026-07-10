#!/usr/bin/env fish

# A simple shell script to install my dotfiles and setup some basics for my system.

git clone https://github.com/NovaFoundSaturn/dotfiles.git

mkdir ~/Projects
mkdir ~/Pictures
rm ~/.config/fish/config.fish

mv ./dotfiles ~/Projects/

# Update and Install new packages
sudo pacman -Syu niri noctalia sddm nautilus ghostty ghostty-nautilus zen-browser-bin github-cli gnome-disk-utility adw-gtk-theme brightnessctl capitaine-cursors xwayland-satellite cachyos-gaming-meta steam discord 

# Enable display manager
sudo systemctl enable sddm

ln -s ~/Projects/dotfiles/.vimrc ~/
ln -s ~/Projects/dotfiles/fastfetch ~/.config
ln -s ~/Projects/dotfiles/niri ~/.config
ln -s ~/Projects/dotfiles/noctalia ~/.config
ln -s ~/Projects/dotfiles/fish/config.fish ~/.config/fish/
ln -s ~/Projects/dotfiles/ghostty ~/.config
ln -s ~/Projects/dotfiles/wallpapers ~/Pictures/Wallpapers
