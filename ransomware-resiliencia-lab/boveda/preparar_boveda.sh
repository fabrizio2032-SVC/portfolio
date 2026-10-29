#!/bin/bash
# preparar_boveda.sh · srv-vault01
# Usuario dedicado, credenciales por cliente (fuera del dominio) y cortafuegos que solo acepta 3 orígenes.
set -euo pipefail

# Únicos tres orígenes que pueden hablar con la bóveda (red corporativa del laboratorio)
IP_SRV_DC01="${IP_SRV_DC01:-198.51.100.10}"
IP_SRV_SVC01="${IP_SRV_SVC01:-198.51.100.20}"
IP_SRV_DOCS01="${IP_SRV_DOCS01:-198.51.100.30}"

REST_SERVER_VERSION="0.13.0"

apt install -y restic btrfs-progs ufw apache2-utils curl
useradd -r -m -d /srv/restic restic || true

# rest-server desde la release oficial del proyecto restic
curl -fsSL "https://github.com/restic/rest-server/releases/download/v${REST_SERVER_VERSION}/rest-server_${REST_SERVER_VERSION}_linux_amd64.tar.gz" \
  | tar -xz -C /tmp
install -m 755 "/tmp/rest-server_${REST_SERVER_VERSION}_linux_amd64/rest-server" /usr/local/bin/rest-server
install -m 644 "$(dirname "$0")/rest-server.service" /etc/systemd/system/rest-server.service

# Una credencial por cliente, distinta de las del dominio (htpasswd pide la contraseña)
for cliente in srv-docs01 srv-dc01 srv-svc01; do
  opciones=(-B)
  [[ -f /srv/restic/.htpasswd ]] || opciones+=(-c)
  sudo -u restic htpasswd "${opciones[@]}" /srv/restic/.htpasswd "$cliente"
done

ufw default deny incoming
for ip in "$IP_SRV_DC01" "$IP_SRV_SVC01" "$IP_SRV_DOCS01"; do
  ufw allow from "$ip" to any port 8000 proto tcp
done
ufw --force enable
systemctl daemon-reload
systemctl enable --now rest-server
systemctl --no-pager status rest-server | head -5
