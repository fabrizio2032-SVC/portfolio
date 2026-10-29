#!/bin/bash
# 03_disco_de_backups.sh · Saca el segundo disco de info-vg y crea backups-vg/tar-lv (1 GB)
set -euo pipefail
DISCO="${DISCO:-/dev/sdc1}"

pvmove "$DISCO"                 # mueve los datos que hubiera en ese PV al otro disco
vgreduce info-vg "$DISCO"
vgcreate backups-vg "$DISCO"
lvcreate -L 1G -n tar-lv backups-vg
mkfs.ext4 /dev/backups-vg/tar-lv
mkdir -p /mnt/backup && mount /dev/backups-vg/tar-lv /mnt/backup
vgs && lvs
