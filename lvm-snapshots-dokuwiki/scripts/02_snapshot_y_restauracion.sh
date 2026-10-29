#!/bin/bash
# 02_snapshot_y_restauracion.sh · Snapshot fechado de web-lv, incidente simulado y recuperación
set -euo pipefail
SNAP="web-lv_snapshot_$(date +%Y%m%d)"
WIKI_DIR="${WIKI_DIR:-/var/webprod/dokuwiki-2020-07-29}"

echo "== 1. Snapshot antes del cambio"
lvcreate -L 500M -s -n "$SNAP" /dev/info-vg/web-lv
lvs info-vg

echo "== 2. Incidente simulado: se borra el código de la wiki"
rm -rf "$WIKI_DIR"
ls -l /var/webprod

echo "== 3. Restauración"
# El merge no se aplica mientras el volumen de origen está montado:
# hay que desmontarlo y reactivarlo para que la fusión se complete.
umount /var/webprod
lvconvert --merge "/dev/info-vg/${SNAP}"
lvchange -an /dev/info-vg/web-lv
lvchange -ay /dev/info-vg/web-lv
mount /var/webprod
ls -l /var/webprod
