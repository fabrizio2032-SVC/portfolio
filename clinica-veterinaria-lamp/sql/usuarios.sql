-- usuarios.sql · Principio de mínimo privilegio
-- La web solo puede INSERTAR citas; recepción solo puede CONSULTARLAS.
CREATE USER IF NOT EXISTS 'web_citas'@'localhost' IDENTIFIED BY 'cambia_esta_contraseña';
GRANT INSERT ON patitas_felices.pacientes TO 'web_citas'@'localhost';

CREATE USER IF NOT EXISTS 'recepcion'@'localhost' IDENTIFIED BY 'cambia_esta_contraseña';
GRANT SELECT ON patitas_felices.pacientes TO 'recepcion'@'localhost';

FLUSH PRIVILEGES;
