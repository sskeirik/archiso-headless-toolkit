#!/bin/bash

# prelude
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -euox

VM_NAME="Arch"
VM_ISO_PATH="$SCRIPT_DIR/archlinux.iso"

if [ ! -f "$VM_ISO_PATH" ]; then
  echo "Error: ISO not found at '$VM_ISO_PATH'"
  exit 1
fi

vboxmanage storagectl "$VM_NAME" --name "IDE Controller" --add ide
vboxmanage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$VM_ISO_PATH"
