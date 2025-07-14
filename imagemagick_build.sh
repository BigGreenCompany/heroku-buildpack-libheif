#!/bin/bash
set -ex

BUILD_DIR=$1
IM_VERSION="7.1.1-46"  # Use latest if needed

IM_BUILD_DIR="/tmp/im-build"
IM_INSTALL_DIR="$BUILD_DIR/.heroku/vendor/imagemagick"
LIBHEIF_DIR="$BUILD_DIR/.heroku/vendor/libheif"

# Clean previous builds
rm -rf "$IM_BUILD_DIR" "$IM_INSTALL_DIR"
mkdir -p "$IM_BUILD_DIR" "$IM_INSTALL_DIR"

cd "$IM_BUILD_DIR"

# Download and extract ImageMagick
curl -LO "https://imagemagick.org/download/releases/ImageMagick-$IM_VERSION.tar.xz"
tar xf "ImageMagick-$IM_VERSION.tar.xz"
cd "ImageMagick-$IM_VERSION"

# Configure ImageMagick with libheif and other formats
PKG_CONFIG_PATH="$LIBHEIF_DIR/lib/pkgconfig:$PKG_CONFIG_PATH" \
LD_LIBRARY_PATH="$LIBHEIF_DIR/lib:$LD_LIBRARY_PATH" \
./configure \
  --prefix="$IM_INSTALL_DIR" \
  --with-heic \
  --with-webp \
  --with-jpeg \
  --with-png \
  --disable-static

# Build and install
make -j4
make install

# Ensure the config directory exists
mkdir -p "$IM_INSTALL_DIR/etc/ImageMagick-7"

# Copy the default configuration files from the source
cp -r ./config/* "$IM_INSTALL_DIR/etc/ImageMagick-7/"

# Confirm install
"$IM_INSTALL_DIR/bin/convert" -version
