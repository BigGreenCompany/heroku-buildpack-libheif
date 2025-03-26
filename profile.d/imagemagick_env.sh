#!/bin/sh

# Let runtime know where to find libheif and other codecs
export LD_LIBRARY_PATH="/app/.heroku/vendor/libheif/lib:$LD_LIBRARY_PATH"
export PATH="/app/.heroku/vendor/imagemagick/bin:$PATH"
