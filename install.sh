#!/usr/bin/env bash

set -e

pkgs=(
    # Desktop
    niri
    noctalia
    sddm
    adw-gtk-theme
    brightnessctl
    capitaine-cursors
    xwayland-satellite

    # Desktop Applications
    nautilus
    ghostty
    ghostty-nautilus
    zen-browser-bin
    gnome-disk-utility
    gnome-calculator
    libreoffice-fresh

    # Dev Tools
    github-cli
    github-desktop
    helix
    qemu-full
    virt-manager

    # Gaming
    cachyos-gaming-meta
    steam
    discord
)

setup_dotfiles() {
    echo "Setting up dotfiles..."

    git clone https://github.com/NovaFoundSaturn/dotfiles.git

    mkdir -p ~/Projects
    mkdir -p ~/Pictures
    mkdir -p ~/.config/fish

    rm -f ~/.config/fish/config.fish

    mv ./dotfiles ~/Projects/

    ln -s ~/Projects/dotfiles/.vimrc ~/
    ln -s ~/Projects/dotfiles/fastfetch ~/.config
    ln -s ~/Projects/dotfiles/niri ~/.config
    ln -s ~/Projects/dotfiles/noctalia ~/.config
    ln -s ~/Projects/dotfiles/fish/config.fish ~/.config/fish/
    ln -s ~/Projects/dotfiles/ghostty ~/.config
    ln -s ~/Projects/dotfiles/wallpapers ~/Pictures/Wallpapers
    ln -s ~/Projects/dotfiles/helix ~/.config/
}

install_packages() {
    echo "Updating system and installing packages..."

    sudo pacman -Syu "${pkgs[@]}"
}

enable_services() {
    echo "Adding user Groups"
    sudo usermod -aG libvirt $USER

    echo "Enabling Display Manager..."

    sudo systemctl enable sddm
    sudo systemctl enable libvirtd
}

main() {
    setup_dotfiles
    install_packages
    enable_services
    echo
    echo "Finished! Please restart."
}

main "$@"
