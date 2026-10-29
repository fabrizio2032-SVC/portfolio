#!/bin/bash
# generar_secretos.sh · Crea el fichero .env de la pila con contraseñas aleatorias.
# Los secretos se generan en el propio servidor y nunca se suben al repositorio (.env está en .gitignore).
set -euo pipefail
cd "$(dirname "$0")/.."
[[ -f .env ]] && { echo ".env ya existe; no se sobrescribe."; exit 0; }

rand() { openssl rand -base64 "${1:-24}" | tr -d '/+=' | cut -c1-"${2:-32}"; }

umask 077
cat > .env <<ENV
PG_ADMIN_USER=resiliencia_admin
PG_ADMIN_PASS=$(rand)
PG_N8N_USER=n8n_writer
PG_N8N_PASS=$(rand)
GRAFANA_RO_PASS=$(rand)
N8N_KEY=$(rand 48 48)
N8N_WEBHOOK_URL=http://srv-svc01:5678/
GF_ADMIN_PASS=$(rand)
ENV
chmod 600 .env
echo "✓ .env creado con permisos 600. Guarda una copia cifrada fuera de línea (la N8N_KEY descifra las credenciales de n8n)."
