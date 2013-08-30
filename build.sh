#!/bin/bash

__FILE__=$(readlink -f "$0")
__DIR__=$(dirname "$__FILE__")

pushd $__DIR__

# remove previous builds
rm -r inotify-*/

# if we don't have a source tarball, download it
if [[ ! -f $(echo inotify-*.tgz) ]]
then
    echo "Downloading latest release..."
    curl -J -O http://pecl.php.net/get/inotify
    [[ $? -ne 0 ]] && exit 1
fi

src_tar=$(find . -maxdepth 1 -name "inotify-*.tgz" | sort -Vr | head -1)

echo "Extracting source traball..."
tar -zxvf "$src_tar"

src_dir=$(find . -maxdepth 1 -type d -name "inotify-*" | sort -Vr | head -1)

# copy post{install,remove} scripts
cp *-pak $src_dir

echo "Building extension..."
pushd "$src_dir"

phpize
[[ $? -ne 0 ]] && exit 1

./configure
[[ $? -ne 0 ]] && exit 2

make
[[ $? -ne 0 ]] && exit 3
make test
[[ $? -ne 0 ]] && exit 4


echo "Will now build debian package..."
sudo checkinstall \
    --install=no \
    --pkgname php5-inotify \
    --provides php5-inotify \
    --requires php5-common \
    --deldoc
[[ $? -ne 0 ]] && exit 5

# cleanup after successfull install
mv *.deb "$__DIR__"
popd
sudo rm -rf inotify-*/
rm package.xml
exit 0
