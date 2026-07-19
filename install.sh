#!/usr/bin/env bash

set -euo pipefail

# CachyOS Post Install Script
#
# 1. Install dependencies
# 2. Select package groups
# 3. Clone and link dotfiles
# 4. Configure groups and services
# 5. Reboot system


# -----------------------------
# Configuration
# -----------------------------

DOTFILES_REPO="https://github.com/NovaFoundSaturn/dotfiles.git"
DOTFILES_DIR="$HOME/Projects/dotfiles"

declare -A PKG_GROUPS=(
    [niri]="niri noctalia sddm adw-gtk-theme brightnessctl capitaine-cursors xwayland-satellite nautilus ghostty ghostty-nautilus zen-browser-bin gnome-disk-utility gnome-calculator libreoffice-fresh"
    [dev]="github-desktop github-cli helix qemu-full virt-manager"
    [gaming]="steam discord cachyos-gaming-meta"
)


# -----------------------------
# Helpers
# -----------------------------

msg() {
    gum style --foreground 212 "$1"
}


require_command() {
    if ! command -v "$1" &>/dev/null; then
        echo "Missing dependency: $1"
        exit 1
    fi
}


# -----------------------------
# Dependencies
# -----------------------------

install_dependencies() {
    if command -v gum &>/dev/null; then
        return
    fi

    echo "Installing gum..."
    sudo pacman -S --needed gum
}


# -----------------------------
# Package Installation
# -----------------------------

install_packages() {
    msg "Select package groups"

    local selected
    selected=$(gum choose --no-limit \
        "niri" \
        "dev" \
        "gaming"
    )

    local packages=()

    while IFS= read -r group; do
        [[ -z "$group" ]] && continue

        read -ra group_packages <<< "${PKG_GROUPS[$group]}"
        packages+=("${group_packages[@]}")
    done <<< "$selected"

    if [[ ${#packages[@]} -eq 0 ]]; then
        echo "No packages selected."
        return
    fi

    echo
    echo "Packages to install:"
    printf " - %s\n" "${packages[@]}"
    echo

    gum confirm "Install these packages?" || return

    sudo pacman -S --needed "${packages[@]}"
}


# -----------------------------
# Dotfiles
# -----------------------------

clone_dotfiles() {
    msg "Setting up dotfiles"

    if [[ -d "$DOTFILES_DIR" ]]; then
        echo "Dotfiles already exist."
        return
    fi

    mkdir -p "$(dirname "$DOTFILES_DIR")"

    gum spin \
        --spinner dot \
        --title "Cloning dotfiles..." \
        -- git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
}


link_dotfiles() {
    msg "Linking dotfiles"

    local files=(
        ".config/niri"
        ".config/noctalia"
        ".config/ghostty"
        ".config/fastfetch"
        ".config/helix"
        ".config/fish/config.fish"
        "Pictures/Wallpapers"
    )

    for file in "${files[@]}"; do
        local source="$DOTFILES_DIR/$file"
        local target="$HOME/$file"

        if [[ ! -e "$source" ]]; then
            echo "Missing: $source"
            continue
        fi

        mkdir -p "$(dirname "$target")"

        if [[ -e "$target" && ! -L "$target" ]]; then
            gum confirm "$target exists. Replace?" || continue
        fi

        ln -sfn "$source" "$target"

        echo "Linked $file"
    done
}


# -----------------------------
# System Setup
# -----------------------------

setup_system() {
    msg "System setup"

    local user_groups=(
        libvirt
    )

    echo "Adding user groups..."

    for group in "${user_groups[@]}"; do
        if getent group "$group" >/dev/null; then
            sudo usermod -aG "$group" "$USER"
            echo "Added $USER to $group"
        else
            echo "Skipping missing group: $group"
        fi
    done


    local services=(
        sddm
        libvirtd
    )

    echo
    echo "Enabling services..."

    for service in "${services[@]}"; do
        if systemctl list-unit-files "${service}.service" &>/dev/null; then
            sudo systemctl enable "$service"
            echo "Enabled $service"
        else
            echo "Skipping missing service: $service"
        fi
    done
}


# -----------------------------
# Main
# -----------------------------

main() {
    clear

    install_dependencies

    require_command gum
    require_command git

    gum style \
        --border double \
        --padding "1 3" \
        "Welcome to Nova's CachyOS Installer"

    gum confirm "Continue?" || exit 0

    clone_dotfiles
    link_dotfiles

    install_packages

    setup_system

    if gum confirm "Reboot now?"; then
        reboot
    fi
}


main
