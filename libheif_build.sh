#!/bin/bash
set -ex

BUILD_DIR=$1  # Passed from bin/compile

# Setup build environment for Heroku
export LD_LIBRARY_PATH="$BUILD_DIR/.apt/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$BUILD_DIR/.apt/lib/pkgconfig:$PKG_CONFIG_PATH"
export CFLAGS="-I$BUILD_DIR/.apt/include"
export LDFLAGS="-L$BUILD_DIR/.apt/lib"

# Set installation and build directories
INSTALL_DIR="$BUILD_DIR/.heroku/vendor/libheif"
BUILD_TMP="/tmp/libheif-build"

# Clean and recreate build directory
rm -rf "$BUILD_TMP"
mkdir -p "$BUILD_TMP"
cd "$BUILD_TMP"

# Download and extract libheif (from self-hosted release)
LIBHEIF_VERSION=1.19.7
LIBHEIF_TARBALL="libheif-${LIBHEIF_VERSION}.tar.gz"
LIBHEIF_URL="https://github.com/BigGreenCompany/heroku-buildpack-libheif/releases/download/v${LIBHEIF_VERSION}/${LIBHEIF_TARBALL}"

echo "⬇️ Downloading libheif ${LIBHEIF_VERSION} from release"
curl -fL "$LIBHEIF_URL" -o "$LIBHEIF_TARBALL"

# Verify gzip archive
file "$LIBHEIF_TARBALL" | grep -q gzip || {
  echo "❌ Downloaded libheif archive is not gzip"
  exit 1
}

# Extract and enter source dir
tar xzf "$LIBHEIF_TARBALL"
cd "libheif-${LIBHEIF_VERSION}"

# Create install structure so Heroku doesn't drop it
mkdir -p "$INSTALL_DIR/bin" "$INSTALL_DIR/lib"

# Create and enter build directory
mkdir build && cd build

# Configure build
cmake -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=ON -DBUILD_HEIF_EXAMPLES=OFF ..

# Compile and install
make -j4
make install

# Debug output: show what was installed
echo "✅ Contents of $INSTALL_DIR/bin:"
ls -l "$INSTALL_DIR/bin" || echo "⚠️ bin folder not found"

echo "✅ Contents of $INSTALL_DIR/lib:"
ls -l "$INSTALL_DIR/lib" || echo "⚠️ lib folder not found"
