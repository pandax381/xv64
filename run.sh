#!/bin/bash

unset REBUILD IDE_MODE

while getopts 'rl' c
do
  case $c in
    r) REBUILD=TRUE ;;
    l) IDE_MODE=TRUE ;;
  esac
done

if [ -n "$REBUILD" ]; then
    ./build.sh || exit 1
fi

NETWORK="-net none"
BOOT_DISK="-hda ./bin/boot.vdi"
ROOT_DISK="-drive id=disk,file=./bin/fs.vdi,if=none -device ide-drive,drive=disk,bus=ahci.0"

if [ -n "$IDE_MODE" ]; then
    ROOT_DISK="-hdb ./bin/fs.vdi"
fi

qemu-system-x86_64 -device ahci,id=ahci -smp 3 -m 512 -nographic $NETWORK $BOOT_DISK $ROOT_DISK
