#!/bin/bash
# 04_backups_tar.sh · Copia completa, incremental y diferencial de la wiki con tar
# -g usa un fichero .snar para recordar qué se copió y guardar solo lo que cambia.
set -euo pipefail
B=/mnt/backup
WIKI=/var/webprod

# 1) Completa: inicia el historial
tar -g "$B/historial.snar" -cvzf "$B/1-full.tar.gz" "$WIKI"
cp "$B/historial.snar" "$B/historial-full.snar"   # foto del historial justo tras la completa

# 2) Incremental: solo lo que ha cambiado desde la última copia (actualiza el historial)
tar -g "$B/historial.snar" -cvzf "$B/2-incremental.tar.gz" "$WIKI"

# 3) Diferencial: todo lo cambiado desde la COMPLETA.
#    Se parte siempre del historial de la completa, no del incremental.
cp "$B/historial-full.snar" "$B/historial-diff.snar"
tar -g "$B/historial-diff.snar" -cvzf "$B/3-diferencial.tar.gz" "$WIKI"

ls -lh "$B"
