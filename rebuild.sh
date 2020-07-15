#!/bin/bash

# prelude
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -euox

# constants
PUBLIC_KEY="$HOME/.ssh/id_rsa.pub"

# create build directory and change to it
rm -f "$SCRIPT_DIR/build"
cp -r /usr/share/archiso/configs/releng/ "$SCRIPT_DIR/build"
cd "$SCRIPT_DIR/build"

# copy PUBLIC_KEY to authorized_keys
mkdir -p airootfs/etc/skel/.ssh
cp $PUBLIC_KEY airootfs/etc/skel/.ssh/authorized_keys
chmod 700 airootfs/etc/skel/.ssh
chmod 600 airootfs/etc/skel/.ssh/authorized_keys

# enable sshd
echo systemctl enable sshd.service \
     >> airootfs/root/customize_airootfs.sh

# run build
sudo "$SCRIPT_DIR/build/build.sh"
