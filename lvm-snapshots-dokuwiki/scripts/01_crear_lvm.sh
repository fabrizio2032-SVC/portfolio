#!/bin/bash
# 01_crear_lvm.sh · Volúmenes físicos, grupo info-vg y volumen lógico web-lv
# ⚠ Borra el contenido de los discos indicados. Úsalo solo en una VM de laboratorio.
set -euo pipefail
DISCOS=(${DISCOS:-/dev/sdb1 /dev/sdc1})   # dos particiones de 5 GB

pvcreate "${DISCOS[@]}"
vgcreate info-vg "${DISCOS[@]}"
lvcreate -L 2G -n web-lv info-vg
mkfs.ext4 /dev/info-vg/web-lv

mkdir -p /var/webprod
mount /dev/info-vg/web-lv /var/webprod
grep -q '/var/webprod' /etc/fstab || echo '/dev/info-vg/web-lv /var/webprod ext4 defaults 0 2' >> /etc/fstab
mount -a
df -h /var/webprod

# Ampliación en caliente a 2,5 GB
lvextend -L 2.5G /dev/info-vg/web-lv
resize2fs /dev/info-vg/web-lv
df -h /var/webprod
