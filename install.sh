#!/usr/bin/env fish

# A simple shell script to install my dotfiles and setup some basics for my system.

set SOURCE "https://github.com/NovaFoundSaturn/dotfiles.git"

begin
    cd ~/Projects/
    git clone $SOURCE
end

set PACKAGES \
niri \
noctalia \
sddm \
nautilus \
ghostty \
ghostty-nautilus \
zen-browser-bin \
github-cli \
gnome-disk-utility \
adw-gtk-theme \
brightnessctl \
capitain-cursors \
xwayland-satellite \
cachyos-gaming-meta \
steam \
discord \
#END PKGS

# Update and Install new packages
sudo pacman -Syu
sudo pacman -S --needed $PACKAGES 

# Enable display manager
sudo systemctl enable sddm

# Create symlinks for dotfiles
sudo rm -r ~/.config/{fastfetch,niri,noctalia,fish,ghostty}

ln -s ~/Projects/dotfiles/.vimrc ~/
ln -s ~/Projects/dotfiles/fastfetch ~/.config
ln -s ~/Projects/dotfiles/niri ~/.config
ln -s ~/Projects/dotfiles/noctalia ~/.config
ln -s ~/Projects/dotfiles/fish/config.fish ~/.config/fish
ln -s ~/Projects/dotfiles/ghostty ~/.config
ln -s ~/Projects/dotfiles/wallpapers ~/Pictures/Wallpapers

# Tell user to Reboot system 
echo "Please Reboot the system."
