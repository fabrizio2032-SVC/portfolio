#!/bin/bash
# preparar_boveda.sh · srv-vault01
# Usuario dedicado, credenciales por cliente (fuera del dominio) y cortafuegos que solo acepta 3 orígenes.
set -euo pipefail

# IPs de los tres clientes autorizados (rellénalas en tu laboratorio)
IP_SRV_DC01="${IP_SRV_DC01:?Indica la IP de srv-dc01}"
IP_SRV_SVC01="${IP_SRV_SVC01:?Indica la IP de srv-svc01}"
IP_SRV_DOCS01="${IP_SRV_DOCS01:?Indica la IP de srv-docs01}"

apt install -y restic btrfs-progs ufw apache2-utils
useradd -r -m -d /srv/restic restic || true

for cliente in srv-docs01 srv-dc01 srv-svc01; do
  sudo -u restic htpasswd -B "$( [[ -f /srv/restic/.htpasswd ]] || echo -c )" /srv/restic/.htpasswd "$cliente"
done

ufw default deny incoming
for ip in "$IP_SRV_DC01" "$IP_SRV_SVC01" "$IP_SRV_DOCS01"; do
  ufw allow from "$ip" to any port 8000 proto tcp
done
ufw enable
systemctl enable --now rest-server
