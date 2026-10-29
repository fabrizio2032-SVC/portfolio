#!/bin/bash
# backup_completo.sh · GlaciaNova (srv-ice01)
# Copia nocturna de los datos, la configuración y la base del dominio al array md2 (/backup).
# Programado en cron de root:  0 2 * * * /usr/local/sbin/backup_completo.sh
set -uo pipefail

BACKUP_DIR="${BACKUP_DIR:-/backup}"            # array RAID md2
EXTERNO="${EXTERNO:-/mnt/backup_externo}"      # disco USB para la regla 3-2-1
read -r -a ORIGENES <<< "${ORIGENES:-/datos /etc /var/lib/samba}"
RETENCION_DIAS=7

FECHA=$(date +%F)
DESTINO="${BACKUP_DIR}/completas/${FECHA}"
LOG="${BACKUP_DIR}/logs/backup_${FECHA}.log"
ESTADO=OK

mkdir -p "$DESTINO" "${BACKUP_DIR}/logs" "${BACKUP_DIR}/restauraciones"
log() { echo "[$(date '+%F %T')] $*" | tee -a "$LOG"; }

log "Inicio de la copia en ${DESTINO}"
for origen in "${ORIGENES[@]}"; do
  mkdir -p "${DESTINO}${origen}"
  if rsync -a --delete "${origen}/" "${DESTINO}${origen}/" >> "$LOG" 2>&1; then
    log "OK    ${origen}"
  else
    log "ERROR ${origen}"; ESTADO=FALLO
  fi
done

log "Retención: se borran copias de más de ${RETENCION_DIAS} días"
find "${BACKUP_DIR}/completas" -mindepth 1 -maxdepth 1 -type d -mtime +"$RETENCION_DIAS" -exec rm -rf {} +

if mountpoint -q "$EXTERNO"; then
  if rsync -a --delete "${DESTINO}/" "${EXTERNO}/ultima/" >> "$LOG" 2>&1; then
    log "OK    copia externa en ${EXTERNO}"
  else
    log "ERROR copia externa"; ESTADO=FALLO
  fi
else
  log "AVISO disco externo no montado, se omite la copia externa"
fi

log "Fin. Estado: ${ESTADO}"
[[ "$ESTADO" == OK ]]
