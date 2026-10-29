<?php
// config.php · Conexión a MySQL
// Las credenciales NO están en el código: Apache las inyecta como variables de entorno
// (las crea sql/crear_usuarios.sh en /etc/apache2/conf-available/patitas-felices-db.conf).
$db_host = getenv('PF_DB_HOST') ?: 'localhost';
$db_user = getenv('PF_DB_USER') ?: 'web_citas';
$db_pass = getenv('PF_DB_PASS') ?: '';
$db_name = getenv('PF_DB_NAME') ?: 'patitas_felices';
