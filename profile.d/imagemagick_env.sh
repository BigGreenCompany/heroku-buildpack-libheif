#!/bin/sh

# Set runtime library paths for both ImageMagick and libheif
export LD_LIBRARY_PATH="/app/.heroku/vendor/imagemagick/lib:/app/.heroku/vendor/libheif/lib:$LD_LIBRARY_PATH"

# Set binary path so convert/magick tools are used from custom install
export PATH="/app/.heroku/vendor/imagemagick/bin:$PATH"
