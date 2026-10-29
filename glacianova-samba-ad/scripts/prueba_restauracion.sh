#!/bin/bash
# prueba_restauracion.sh · GlaciaNova
# Demuestra que la copia sirve: crea un fichero, hace backup, lo borra y lo restaura.
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/backup}"
SCRIPT_BACKUP="${SCRIPT_BACKUP:-/usr/local/sbin/backup_completo.sh}"
PRUEBA="${PRUEBA:-/datos/compartido/comun/prueba_restauracion.txt}"

echo "Prueba de restauración $(date '+%F %T')" > "$PRUEBA"
ORIGINAL=$(sha256sum "$PRUEBA" | cut -d' ' -f1)

"$SCRIPT_BACKUP"
rm -f "$PRUEBA"
[[ -e "$PRUEBA" ]] || echo "Fichero borrado para simular la pérdida"

rsync -a "${BACKUP_DIR}/completas/$(date +%F)${PRUEBA}" "$PRUEBA"
RESTAURADO=$(sha256sum "$PRUEBA" | cut -d' ' -f1)

if [[ "$ORIGINAL" == "$RESTAURADO" ]]; then
  echo "✓ Restauración correcta: el contenido coincide con el original"
else
  echo "✗ El fichero restaurado no coincide" >&2; exit 1
fi
