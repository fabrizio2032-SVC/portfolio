-- schema.sql · Base de datos de la web de citas
CREATE DATABASE IF NOT EXISTS patitas_felices
  CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE patitas_felices;

CREATE TABLE IF NOT EXISTS pacientes (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  nombre_mascota  VARCHAR(100) NOT NULL,
  especie         VARCHAR(50)  NOT NULL,
  nombre_dueno    VARCHAR(100) NOT NULL,
  fecha_cita      DATE         NOT NULL,
  creado_en       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);
