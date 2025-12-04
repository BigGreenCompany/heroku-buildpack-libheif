# heroku-buildpack-libheif
Buildpack for heroku to install the latest version of libheif so that we can process iPhone 15 heic images

## Aptfile
Add an Aptfile in your app root:
```
build-essential
cmake
pkg-config
curl
git

libde265-dev
libx265-dev
libaom-dev
libdav1d-dev
libjpeg-dev
libpng-dev
libwebp-dev
librhash-dev
```

## Test on Heroku

### Check if libheif is installed:
```
heroku bash -a YOUR_APP_NAME
convert -list format | grep HEIC
```
Expected Output(Check the version: 1.19.7):
```
HEIC rw+   Apple High efficiency Image Format (1.19.7)
```

### Check if ImageMagick is installed:

```
heroku run -a YOUR_APP_NAME "convert -version"

```
Expected Output(Check the version: 7.1.1-46):
```
Version: ImageMagick 7.1.1-46 Q16-HDRI x86_64 22747 https://imagemagick.org
```

