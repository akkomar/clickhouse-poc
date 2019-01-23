#!/bin/bash
set -euxo pipefail

# TODO: these should be passed from provisioner
MNT_DIR="/mnt/disks/clickhouse-data"
DEVICE="/dev/disk/by-id/google-clickhouse-data"


if [ ! -d "$MNT_DIR" ]; then
  mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard $DEVICE
  mkdir -p $MNT_DIR
  mount -o discard,defaults $DEVICE $MNT_DIR
  chmod a+w $MNT_DIR
  echo UUID=`blkid -s UUID -o value $DEVICE` $MNT_DIR ext4 discard,defaults,nofail 0 2 | tee -a /etc/fstab
fi
