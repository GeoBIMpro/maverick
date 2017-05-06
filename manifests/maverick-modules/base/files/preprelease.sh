#!/bin/bash

### Script to prepare maverick for release.
# https://github.com/fnoop/maverick/issues/248
# This isn't really a puppet type action, but is hidden down in base module
#  so it's not found and run by accident, as it deletes all user data.
# It must be run as root, otherwise it will fail dismally.

# Clean packages and cache
apt autoremove --purge -y
apt-get clean

# Clean as much of /var/log as possible
rm -f /var/log/*.log*
rm -f /var/log/apt/*
rm -f -rf /var/log/installer
rm -f /var/log/faillog /var/log/lastlog
rm -f /var/log/lightdm/*
rm -f /var/log/syslog* /var/log/dmesg
rm -f /var/log/unattended-upgrades/*
rm -f /var/log/btmp* /var/log/wtmp*

# Remove tmp user used to initially install OS
rm -rf /home/tmp
userdel tmp

# Remove initial bootstrap maverick from common locations
rm -rf /root/maverick
rm -rf /home/pi/maverick

# Remove any root data
rm -rf /root/.cache /root/.gnupg

# Remove build directories (leave install flags in place)
rm -rf /srv/maverick/var/build/*

# Clean up maverick user data
# Note: MUST rerun maverick configure again after removing these files, to restore defaults.
# Otherwise odd behaviour will happen.
rm /srv/maverick/.bash_history
rm /srv/maverick/.c9/state.settings
rm -rf /srv/maverick/.c9/metadata/workspace/*
rm -rf /srv/maverick/.cache /srv/maverick/.config /srv/maverick/.gconf /srv/maverick/.gnupg /srv/maverick/.ICEauthority /srv/maverick/.local 
gst-inspect-1.0 # restore gstreameer .cache
rm -rf /srv/maverick/.gitconfig /srv/maverick/.git-credential-cache /srv/maverick/.subversion
rm -rf /srv/maverick/.[Xx]*
rm -rf /srv/maverick/.ros/log/*

# Clean up maverick data
find /srv/maverick/data/logs -type f -delete
rm -f /srv/maverick/data/vision_landing/*
rm -f /srv/maverick/var/log/mavlink-fc/* /srv/maverick/var/log/mavlink-sitl/*
rm -rf /srv/maverick/var/log/sitl/*
rm -f /srv/maverick/var/log/vision/* /srv/maverick/var/log/vision_landing/*

# Create generic EFI boot
mkdir /boot/efi/EFI/BOOT
cp /boot/efi/EFI/ubuntu/grubx64.efi /boot/efi/EFI/BOOT/bootx64.efi