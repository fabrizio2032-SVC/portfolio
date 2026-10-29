#!/bin/bash
# 02_roles.sh · Se ejecuta una vez al crear la base de datos (docker-entrypoint-initdb.d).
# Crea los roles de la aplicación con las contraseñas del .env y el mínimo privilegio para cada uno.
set -euo pipefail
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
     -v n8n_user="$PG_N8N_USER" -v n8n_pass="$PG_N8N_PASS" -v ro_pass="$GRAFANA_RO_PASS" <<'SQL'
CREATE ROLE :"n8n_user" LOGIN PASSWORD :'n8n_pass';
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO :"n8n_user";
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO :"n8n_user";

CREATE ROLE grafana_ro LOGIN PASSWORD :'ro_pass';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO grafana_ro;
SQL
