#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake       \
    fmt         \
    libsodium   \
	lua			\
    sdl2-compat \
	sdl3_image

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini sdl2_image-mini

echo "Building DevilutionX..."
echo "---------------------------------------------------------------"
REPO="https://github.com/diasurgical/devilutionX"
if [ "${DEVEL_RELEASE-}" = 1 ]; then
    echo "Making nightly build of DevilutionX..."
    echo "---------------------------------------------------------------"
    VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
    git clone --depth 1 "$REPO" ./devilutionX
	FLAGS+=(-DUSE_SDL3=ON)
else
    echo "Making stable build of DevilutionX..."
    VERSION="$(git ls-remote --tags --sort="v:refname" "$REPO" | tail -n1 | sed 's/.*\///; s/\^{}//')"
    git clone --branch "$VERSION" --single-branch --depth 1 "$REPO" ./devilutionX
    FLAGS+=(-DDEVILUTIONX_SYSTEM_LIBFMT=OFF -DDEVILUTIONX_STATIC_LIBFMT=ON)
fi
echo "$VERSION" > ~/version

cmake -S ./devilutionX -B build "${FLAGS[@]}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DBUILD_TESTING=off \
    -DCPACK=ON
cmake --build build -j$(nproc)
cmake --install build
