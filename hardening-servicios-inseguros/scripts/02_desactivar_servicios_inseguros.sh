#!/bin/bash
# 02_desactivar_servicios_inseguros.sh · Contramedida: quitar FTP vulnerable y Telnet
# Sustituirlos por SSH/SFTP, que cifran credenciales y datos.
set -uo pipefail

desactivar() {
  local svc="$1"
  if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files | grep -q "^${svc}"; then
    systemctl disable --now "$svc" && echo "✓ $svc desactivado (systemd)"
  elif [[ -x "/etc/init.d/$svc" ]]; then
    "/etc/init.d/$svc" stop; update-rc.d -f "$svc" remove && echo "✓ $svc desactivado (init.d)"
  fi
}

desactivar vsftpd
desactivar telnet
desactivar xinetd

# Servicios lanzados por (x)inetd: comentar sus líneas
for f in /etc/inetd.conf /etc/xinetd.d/telnet; do
  [[ -f "$f" ]] && sed -i -E 's/^(\s*)(telnet|ftp)/#\1\2/' "$f" && echo "✓ revisado $f"
done

# Alternativa segura
command -v sshd >/dev/null && systemctl enable --now ssh 2>/dev/null || true
echo "Comprueba el resultado con: ss -tulpn | grep -E ':(21|22|23)\b'"
