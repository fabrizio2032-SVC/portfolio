#!/bin/bash
# crear_estructura_ad.sh · GlaciaNova
# Crea las UO, los grupos de seguridad y las carpetas compartidas con sus permisos.
# Ejecutar en srv-ice01 como root después de provisionar el dominio.
set -euo pipefail

DOMINIO_DN="DC=glacianova,DC=local"
DEPARTAMENTOS=(Ventas Logistica Administracion IT)

echo "== Unidades organizativas"
for ou in "${DEPARTAMENTOS[@]}"; do
  samba-tool ou create "OU=${ou},${DOMINIO_DN}" || echo "   (ya existe OU=${ou})"
done

echo "== Grupos de seguridad"
for grupo in Ventas Logistica Administracion IT_ADM; do
  samba-tool group add "$grupo" || echo "   (ya existe ${grupo})"
done

echo "== Carpetas compartidas en el array md1 (/datos)"
mkdir -p /datos/perfiles /datos/compartido/{ventas,logistica,administracion,comun}
chmod 1777 /datos/perfiles
for dep in ventas logistica administracion; do
  grupo="$(tr '[:lower:]' '[:upper:]' <<< "${dep:0:1}")${dep:1}"
  chown root:"GLACIANOVA\\${grupo}" "/datos/compartido/${dep}"
  chmod 2770 "/datos/compartido/${dep}"   # SETGID: los ficheros heredan el grupo
done
chmod 1777 /datos/compartido/comun

echo "== Listado final"
samba-tool ou list
samba-tool group list | grep -E 'Ventas|Logistica|Administracion|IT_ADM'

# Usuarios: créalos con contraseña segura y añádelos a su grupo, por ejemplo:
#   samba-tool user create jgomez --given-name=Juan --surname=Gomez
#   samba-tool group addmembers Ventas jgomez
