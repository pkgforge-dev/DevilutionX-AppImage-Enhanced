#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake     \
    libdecor  \
    ninja     \
    fmt       \
    libsodium \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano sdl2_image-mini

# Comment this out if you need an AUR package
make-aur-package

# If the application needs to be manually built that has to be done down here
