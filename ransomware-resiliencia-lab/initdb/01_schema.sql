-- initdb/01_schema.sql · trazabilidad de copias, incidentes y restauraciones
CREATE TABLE sistemas (
  id          SERIAL PRIMARY KEY,
  nombre      VARCHAR(60) UNIQUE NOT NULL,
  ip          INET NOT NULL,
  rol         VARCHAR(80),
  criticidad  SMALLINT CHECK (criticidad BETWEEN 1 AND 4),
  rto_horas   SMALLINT,
  rpo_horas   SMALLINT
);

CREATE TABLE copias (
  id            BIGSERIAL PRIMARY KEY,
  sistema_id    INT REFERENCES sistemas(id),
  snapshot_id   VARCHAR(64) UNIQUE NOT NULL,
  inicio        TIMESTAMPTZ NOT NULL,
  fin           TIMESTAMPTZ,
  bytes_nuevos  BIGINT,
  estado        VARCHAR(12) CHECK (estado IN ('OK','FALLIDA','VERIFICADA')),
  verificada_en TIMESTAMPTZ
);

CREATE TABLE incidentes (
  id           BIGSERIAL PRIMARY KEY,
  huella       CHAR(64) UNIQUE NOT NULL,          -- evita duplicados
  sistema_id   INT REFERENCES sistemas(id),
  tipo         VARCHAR(40) NOT NULL,
  gravedad     CHAR(2) CHECK (gravedad IN ('N1','N2','N3','N4')),
  detectado_en TIMESTAMPTZ DEFAULT now(),
  estado       VARCHAR(12) DEFAULT 'ABIERTO',
  descripcion  TEXT
);

CREATE TABLE restauraciones (
  id             BIGSERIAL PRIMARY KEY,
  incidente_id   BIGINT REFERENCES incidentes(id),
  snapshot_id    VARCHAR(64) REFERENCES copias(snapshot_id),
  destino        VARCHAR(60) NOT NULL,
  solicitada_por VARCHAR(80) NOT NULL,
  inicio         TIMESTAMPTZ DEFAULT now(),
  fin            TIMESTAMPTZ,
  estado         VARCHAR(12) DEFAULT 'EN_CURSO'
                 CHECK (estado IN ('EN_CURSO','EXITOSA','FALLIDA','REVERTIDA'))
);

CREATE TABLE logs_workflow (
  id        BIGSERIAL PRIMARY KEY,
  workflow  VARCHAR(60) NOT NULL,
  nodo      VARCHAR(60),
  nivel     VARCHAR(8) CHECK (nivel IN ('INFO','WARN','ERROR')),
  mensaje   TEXT,
  creado_en TIMESTAMPTZ DEFAULT now()
);

-- Rol de solo lectura para Grafana. Cambia la contraseña en el despliegue real.
CREATE ROLE grafana_ro LOGIN PASSWORD 'cambiar';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO grafana_ro;
