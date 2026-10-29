#!/bin/bash
# comprobar_antes_de_subir.sh · Busca datos que NO deberían acabar en GitHub
# Uso:  bash comprobar_antes_de_subir.sh ../glacianova-samba-ad   (o sin argumento para revisar todo)
RAIZ="${1:-..}"
problemas=0
avisa() { echo "⚠  $1"; problemas=$((problemas+1)); }

echo "Revisando: $RAIZ"
# 1) Direcciones IPv4 (se ignoran 127.0.0.1 y 0.0.0.0)
ips=$(grep -rnoE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$RAIZ" --exclude-dir=.git --exclude-dir=_herramientas \
      | grep -vE ':(127\.0\.0\.1|0\.0\.0\.0|255\.[0-9.]+)$')
[[ -n "$ips" ]] && { avisa "Posibles direcciones IP:"; echo "$ips" | head -20; }

# 2) Contraseñas escritas en claro
pw=$(grep -rniE '(password|passwd|contraseña|pass)\s*[:=]\s*["'"'"']?[^<"'"'"' ]{4,}' "$RAIZ" --exclude-dir=.git --exclude-dir=_herramientas \
     | grep -viE 'cambia|cambiar|example|ejemplo|<|\$\{|\$db_pass|PASSWORD_FILE|_PASS\}' )
[[ -n "$pw" ]] && { avisa "Posibles contraseñas:"; echo "$pw" | head -20; }

# 3) Claves privadas y ficheros de secretos
grep -rlE 'BEGIN (RSA|OPENSSH|EC|PRIVATE) .*KEY' "$RAIZ" --exclude-dir=.git 2>/dev/null | while read -r f; do avisa "Clave privada en $f"; done
find "$RAIZ" -name '.env' -o -name 'config.php' -o -name '*.pem' -o -name 'wg0.conf' 2>/dev/null | grep -v '/.git/' | while read -r f; do avisa "Fichero de secretos: $f"; done

# 4) Teléfonos españoles
tel=$(grep -rnoE '(^|[ :>("])(\+34[ -]?)?[67][0-9]{2}[ -]?[0-9]{3}[ -]?[0-9]{3}\b' "$RAIZ" --exclude-dir=.git --include='*.md' --include='*.html' --include='*.php')
[[ -n "$tel" ]] && { avisa "Posibles teléfonos móviles:"; echo "$tel" | head; }

echo
if [[ $problemas -eq 0 ]]; then echo "✅ No he encontrado nada sospechoso."; else echo "Revisa los avisos anteriores antes de subir."; fi
