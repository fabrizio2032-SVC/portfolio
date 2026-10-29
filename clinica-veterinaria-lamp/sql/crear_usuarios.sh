#!/bin/bash
# crear_usuarios.sh · Principio de mínimo privilegio en MySQL
#  - web_citas: solo puede INSERTAR citas (lo usa registro.php)
#  - recepcion: solo puede CONSULTAR citas
# Genera contraseñas aleatorias, crea los usuarios y pasa las credenciales de la web a Apache
# como variables de entorno, para que nunca estén escritas en el código.
set -euo pipefail
rand() { openssl rand -base64 24 | tr -d '/+=' | cut -c1-24; }
PASS_WEB=$(rand); PASS_RECEPCION=$(rand)

mysql <<SQL
CREATE USER IF NOT EXISTS 'web_citas'@'localhost' IDENTIFIED BY '${PASS_WEB}';
ALTER USER 'web_citas'@'localhost' IDENTIFIED BY '${PASS_WEB}';
GRANT INSERT ON patitas_felices.pacientes TO 'web_citas'@'localhost';

CREATE USER IF NOT EXISTS 'recepcion'@'localhost' IDENTIFIED BY '${PASS_RECEPCION}';
ALTER USER 'recepcion'@'localhost' IDENTIFIED BY '${PASS_RECEPCION}';
GRANT SELECT ON patitas_felices.pacientes TO 'recepcion'@'localhost';
FLUSH PRIVILEGES;
SQL

CONF=/etc/apache2/conf-available/patitas-felices-db.conf
umask 077
cat > "$CONF" <<APACHE
SetEnv PF_DB_HOST localhost
SetEnv PF_DB_USER web_citas
SetEnv PF_DB_PASS ${PASS_WEB}
SetEnv PF_DB_NAME patitas_felices
APACHE
chown root:root "$CONF"; chmod 600 "$CONF"
a2enconf patitas-felices-db >/dev/null && systemctl reload apache2

echo "✓ Usuarios creados. Contraseña de 'recepcion' (entrégala en persona y no la guardes en claro):"
echo "  ${PASS_RECEPCION}"
mysql -e "SHOW GRANTS FOR 'web_citas'@'localhost'; SHOW GRANTS FOR 'recepcion'@'localhost';"
