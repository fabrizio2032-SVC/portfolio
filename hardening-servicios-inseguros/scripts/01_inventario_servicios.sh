#!/bin/bash
# 01_inventario_servicios.sh · ¿Qué está escuchando este servidor y con qué versión?
# Ejecutar en el propio servidor auditado (o en la máquina de análisis de la red aislada).
set -uo pipefail
OBJETIVO="${1:-localhost}"

echo "== Puertos en escucha (local)"
ss -tulpn 2>/dev/null || netstat -tulpn

echo "== Servicios y versiones vistos desde la red"
nmap -sV "$OBJETIVO"

echo "== Protocolos sin cifrar que deberían estar cerrados"
for puerto in 21 23 512 513 514; do
  if nc -z -w2 "$OBJETIVO" "$puerto" 2>/dev/null; then
    echo "  ✗ $puerto/tcp abierto: revisar o desactivar"
  else
    echo "  ✓ $puerto/tcp cerrado"
  fi
done
