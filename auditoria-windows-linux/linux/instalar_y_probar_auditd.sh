#!/bin/bash
# instalar_y_probar_auditd.sh · Ubuntu Server
set -euo pipefail
apt install -y auditd libpam-pwquality
systemctl enable --now auditd

mkdir -p /srv/confidencial
echo "documento de prueba" > /srv/confidencial/topsecurity.txt
cp "$(dirname "$0")/audit.rules" /etc/audit/rules.d/audit.rules
augenrules --load
auditctl -l                                  # reglas activas

# Generar un evento y leerlo con la fecha y hora traducidas (-i)
echo "cambio" >> /srv/confidencial/topsecurity.txt
ausearch -k acceso_fichero -i | tail -n 20
aureport -f --summary | head
