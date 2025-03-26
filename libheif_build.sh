#!/bin/bash
set -ex

# Setup build environment for Heroku
export LD_LIBRARY_PATH="$BUILD_DIR/.apt/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$BUILD_DIR/.apt/lib/pkgconfig:$PKG_CONFIG_PATH"
export CFLAGS="-I$BUILD_DIR/.apt/include"
export LDFLAGS="-L$BUILD_DIR/.apt/lib"

# Set installation and build directories
INSTALL_DIR="$BUILD_DIR/.heroku/vendor/libheif"
BUILD_DIR="/tmp/libheif-build"

# Clean and recreate build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Download and extract libheif
curl -LO https://github.com/strukturag/libheif/releases/download/v1.19.7/libheif-1.19.7.tar.gz
tar xzf libheif-1.19.7.tar.gz
cd libheif-1.19.7

# Create install structure so Heroku doesn't drop it
mkdir -p "$INSTALL_DIR/bin" "$INSTALL_DIR/lib"

# Create and enter build directory
mkdir build && cd build

# Configure build
cmake -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=ON -DBUILD_HEIF_EXAMPLES=ON ..

# Compile and install
make -j4
make install

# Debug output: show what was installed
echo "✅ Contents of $INSTALL_DIR/bin:"
ls -l "$INSTALL_DIR/bin" || echo "⚠️ bin folder not found"

echo "✅ Contents of $INSTALL_DIR/lib:"
ls -l "$INSTALL_DIR/lib" || echo "⚠️ lib folder not found"
