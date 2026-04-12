#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q devilutionx | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/512x512/apps/devilutionx.png
export DESKTOP=/usr/share/applications/devilutionx.desktop
export STARTUPWMCLASS=devilutionx
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/devilutionx

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
