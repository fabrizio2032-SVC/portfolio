#!/bin/bash
# backup_restic.sh · srv-docs01
# Copia diaria de los expedientes a la bóveda. Programar con un temporizador de systemd.
# El fichero de contraseña está fuera del repositorio (chmod 600).
set -euo pipefail
export RESTIC_REPOSITORY="rest:http://srv-docs01:${RESTIC_HTTP_PASS:?}@srv-vault01:8000/srv-docs01"
export RESTIC_PASSWORD_FILE=/root/.restic_pass

restic backup /srv/expedientes --tag diaria
restic check --read-data-subset=5%      # verificación periódica de integridad
