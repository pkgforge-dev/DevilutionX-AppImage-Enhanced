#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm cmake \
    ninja       \
    fmt         \
    libsodium   \
    sdl2-compat \
    sdl2_image

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package

# If the application needs to be manually built that has to be done down here
