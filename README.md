php-inotify-installer
=====================

Little script to ease the installation of the inotify extension on Debian.

```sh
# Install the dependencies
sudo aptitude install tar curl php-dev checkinstall

# build...
cd /path/to/php-inotify-installer
./build.sh

# and install
sudo dpkg -i ./php5-inotify_*.deb
```
