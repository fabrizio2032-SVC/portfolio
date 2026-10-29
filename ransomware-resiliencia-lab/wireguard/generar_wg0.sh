#!/bin/bash
# generar_wg0.sh · srv-svc01
# Genera las claves del servidor y de un administrador y escribe la configuración de WireGuard.
# Las claves privadas se quedan en el servidor (/etc/wireguard, permisos 600): nunca en el repositorio.
set -euo pipefail
ADMIN="${1:-admin1}"
RED_VPN="192.0.2"            # red del túnel (rango de documentación RFC 5737)
IFACE_LAN="${IFACE_LAN:-ens18}"
DIR=/etc/wireguard
umask 077; mkdir -p "$DIR"

[[ -f $DIR/servidor.key ]] || wg genkey | tee "$DIR/servidor.key" | wg pubkey > "$DIR/servidor.pub"
wg genkey | tee "$DIR/$ADMIN.key" | wg pubkey > "$DIR/$ADMIN.pub"

cat > "$DIR/wg0.conf" <<CONF
[Interface]
Address = ${RED_VPN}.1/24
ListenPort = 51820
PrivateKey = $(cat "$DIR/servidor.key")
PostUp   = iptables -A FORWARD -i wg0 -o ${IFACE_LAN} -j ACCEPT
PostDown = iptables -D FORWARD -i wg0 -o ${IFACE_LAN} -j ACCEPT

[Peer]
# ${ADMIN}
PublicKey = $(cat "$DIR/$ADMIN.pub")
AllowedIPs = ${RED_VPN}.2/32
CONF

# Configuración para el portátil del administrador
cat > "$DIR/$ADMIN-cliente.conf" <<CONF
[Interface]
Address = ${RED_VPN}.2/32
PrivateKey = $(cat "$DIR/$ADMIN.key")

[Peer]
PublicKey = $(cat "$DIR/servidor.pub")
Endpoint = srv-svc01:51820
AllowedIPs = ${RED_VPN}.0/24, 198.51.100.0/24
CONF

systemctl enable --now wg-quick@wg0
wg show
echo "✓ Entrega $DIR/$ADMIN-cliente.conf al administrador por un canal seguro y bórralo del servidor."
