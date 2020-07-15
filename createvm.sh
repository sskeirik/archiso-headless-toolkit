#!/bin/bash

# prelude
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -euox

VM_NAME="Arch"
VM_ROOT="$HOME/VMs"
VM_FOLDER="$VM_ROOT/$VM_NAME"
VM_DISK="$VM_FOLDER/$VM_NAME.vdi"
VM_DISK_SIZE=128
VM_MEM_SIZE=8
VM_ISO_PATH="$SCRIPT_DIR/archlinux.iso"

if [ ! -f "$VM_ISO_PATH" ]; then
  echo "Error: ISO not found at '$VM_ISO_PATH'"
  exit 1
fi

vboxmanage createvm --basefolder "$VM_ROOT" --name "$VM_NAME" --register
vboxmanage createmedium disk --filename "$VM_DISK" --size $(( 1024 * $VM_DISK_SIZE ))
vboxmanage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAHCI
vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VM_DISK"
vboxmanage storagectl "$VM_NAME" --name "IDE Controller" --add ide
vboxmanage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$VM_ISO_PATH"
# vboxmanage modifyvm "$VM_NAME" --ioapic on
vboxmanage modifyvm "$VM_NAME" --memory $(( 1024 * $VM_MEM_SIZE ))
vboxmanage modifyvm "$VM_NAME" --nic1 nat
vboxmanage modifyvm "$VM_NAME" --natpf1 "guestssh,tcp,,2222,,22"
vboxmanage modifyvm "$VM_NAME" --natdnshostresolver1 on
