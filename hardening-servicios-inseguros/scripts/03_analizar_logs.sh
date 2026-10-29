#!/bin/bash
# 03_analizar_logs.sh · Buscar el rastro de accesos e intentos en los logs del sistema
set -uo pipefail
AUTH=/var/log/auth.log
WEB=/var/log/apache2/access.log

echo "== Intentos de contraseña fallidos (posible fuerza bruta)"
grep 'Failed password' "$AUTH" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' | sort | uniq -c | sort -rn | head

echo "== Usuarios que no existen (diccionario de usuarios)"
grep 'Invalid user' "$AUTH" | tail -n 10

echo "== Accesos correctos: ¿alguno sigue a muchos fallos?"
grep 'Accepted password' "$AUTH" | tail -n 10

echo "== Web: errores 404 (enumeración) y 500 (fallos del servidor)"
[[ -f "$WEB" ]] && { grep ' 404 ' "$WEB" | wc -l; grep ' 500 ' "$WEB" | tail -n 5; }

echo "== Conexiones registradas en syslog"
grep -i 'connection' /var/log/syslog | tail -n 10
