#!/bin/bash
set -ex

BUILD_DIR=$1
IM_INSTALL_DIR="$BUILD_DIR/.heroku/vendor/imagemagick"

# Clean previous installs
rm -rf "$IM_INSTALL_DIR"
mkdir -p "$IM_INSTALL_DIR"

# Download precompiled ImageMagick from GitHub Release
curl -L -o imagemagick.tar.gz "https://github.com/BigGreenCompany/heroku-buildpack-libheif/releases/download/imagemagick-7.1.1-46-heroku24/ImageMagick-heroku24-7.1.1-46.tar.gz"

# Extract into Heroku vendor directory
tar -xzf imagemagick.tar.gz -C "$IM_INSTALL_DIR"

# 🔥 Critical: Make sure Heroku can find ImageMagick libraries
export LD_LIBRARY_PATH="$IM_INSTALL_DIR/lib:$LD_LIBRARY_PATH"

# Verify installation
"$IM_INSTALL_DIR/bin/convert" -version
