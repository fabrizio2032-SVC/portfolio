#!/bin/bash
# canario.sh · srv-docs01
# Vigila los ficheros señuelo. Si alguien los modifica, renombra o borra (típico de un cifrado
# masivo), envía un webhook a n8n con una huella del evento para que abra el incidente.
# Requiere: apt install inotify-tools curl
set -euo pipefail
CARPETA=/srv/expedientes/_canario
WEBHOOK="${WEBHOOK:-http://srv-svc01:5678/webhook/canario}"

inotifywait -m -e modify,move,delete,attrib --format '%e %w%f' "$CARPETA" |
while read -r evento fichero; do
  ahora=$(date -Is)
  huella=$(printf '%s|%s|%s' "$(hostname)" "$fichero" "${ahora:0:16}" | sha256sum | cut -d' ' -f1)
  curl -fsS -X POST "$WEBHOOK" -H 'Content-Type: application/json' \
    -d "{\"origen\":\"$(hostname)\",\"tipo\":\"canario\",\"evento\":\"$evento\",\"fichero\":\"$fichero\",\"hora\":\"$ahora\",\"huella\":\"$huella\"}" \
    || logger -t canario "No se pudo avisar a n8n: $evento $fichero"
done
