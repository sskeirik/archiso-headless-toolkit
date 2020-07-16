#!/bin/bash

# prelude
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -euox

VM_NAME="Arch"

vboxmanage storagectl "$VM_NAME" --name "IDE Controller" --discard
