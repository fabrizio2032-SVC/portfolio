<?php
// registro.php · Formulario de reserva de citas conectado a MySQL (patitas_felices.pacientes)
//
// Mejoras respecto a la primera versión de la práctica:
//  1. Credenciales fuera del código (config.php, que no se sube al repositorio).
//  2. Consulta preparada: los datos del formulario nunca se concatenan en el SQL (evita inyección SQL).
//  3. Validación de los campos y escape de la salida con htmlspecialchars.
//  4. Usuario de MySQL con permisos mínimos (solo INSERT), nunca root.

require __DIR__ . '/config.php';   // define $db_host, $db_user, $db_pass, $db_name

$mensaje = '';
$ok = false;
$especies_validas = ['Perro', 'Gato', 'Mono', 'Conejo', 'Otro'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nombre_m = trim($_POST['nombre_mascota'] ?? '');
    $especie  = $_POST['especie'] ?? '';
    $dueno    = trim($_POST['nombre_dueno'] ?? '');
    $fecha    = $_POST['fecha_cita'] ?? '';

    $fecha_ok = DateTime::createFromFormat('Y-m-d', $fecha) !== false;

    if ($nombre_m === '' || $dueno === '' || !in_array($especie, $especies_validas, true) || !$fecha_ok) {
        $mensaje = 'Revisa los datos del formulario: todos los campos son obligatorios.';
    } else {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
        try {
            $conn = new mysqli($db_host, $db_user, $db_pass, $db_name);
            $conn->set_charset('utf8mb4');
            $stmt = $conn->prepare(
                'INSERT INTO pacientes (nombre_mascota, especie, nombre_dueno, fecha_cita) VALUES (?, ?, ?, ?)'
            );
            $stmt->bind_param('ssss', $nombre_m, $especie, $dueno, $fecha);
            $stmt->execute();
            $ok = true;
            $mensaje = 'GRACIAS POR RESERVAR CON NOSOTROS. ¡TE ESPERAMOS!';
        } catch (mysqli_sql_exception $e) {
            error_log('registro.php: ' . $e->getMessage());   // el detalle va al log, no al visitante
            $mensaje = 'No hemos podido guardar la reserva. Inténtalo de nuevo más tarde.';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="estilos.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <title>Reserva | Patitas Felices</title>
</head>
<body class="bg-vete-main">
  <header class="vete-header">
    <div class="logo-area">
      <i class="fas fa-paw fa-3x vete-icon"></i>
      <span class="vete-name">Patitas Felices</span>
    </div>
    <nav class="vete-nav-main">
      <a href="index.php">Inicio</a>
      <a href="animales.php">Animales</a>
      <a href="ubicacion.php">Madrid</a>
      <a href="registro.php" class="active btn-primary">Registrar Caso</a>
    </nav>
  </header>

  <section class="vete-section vete-hero" style="background-image: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('https://images.unsplash.com/photo-1596792471911-2555546522c7?q=80&w=2070&auto=format&fit=crop'); background-position: center; background-size: cover;">
    <div class="vete-hero-content" style="text-align: center;">
      <h1>REGÍSTRATE Y RESERVA UNA CITA CON NOSOTROS</h1>
      <p>Tu mascota merece la mejor atención de Madrid. Déjanos sus datos y nos vemos pronto.</p>
    </div>
  </section>

  <div class="vete-container-main">
    <div class="card-luxe form-card">
      <?php if ($mensaje !== ''): ?>
        <div class="aviso <?= $ok ? 'aviso-ok' : 'aviso-error' ?>">
          <i class="fas <?= $ok ? 'fa-check-circle' : 'fa-exclamation-triangle' ?>"></i>
          <?= htmlspecialchars($mensaje, ENT_QUOTES, 'UTF-8') ?>
        </div>
      <?php endif; ?>

      <form action="registro.php" method="POST" class="vete-form">
        <div class="form-group">
          <label for="nombre_mascota"><i class="fas fa-dog"></i> Nombre de la Mascota</label>
          <input type="text" id="nombre_mascota" name="nombre_mascota" maxlength="100" placeholder="Ej: Max" required>
        </div>
        <div class="form-group">
          <label for="especie"><i class="fas fa-list"></i> Especie</label>
          <select id="especie" name="especie" required>
            <option value="Perro">Perro</option>
            <option value="Gato">Gato</option>
            <option value="Mono">Mono Doméstico</option>
            <option value="Conejo">Pequeño Mamífero</option>
            <option value="Otro">Otro</option>
          </select>
        </div>
        <div class="form-group">
          <label for="nombre_dueno"><i class="fas fa-user"></i> Nombre del Dueño</label>
          <input type="text" id="nombre_dueno" name="nombre_dueno" maxlength="100" placeholder="Tu nombre completo" required>
        </div>
        <div class="form-group">
          <label for="fecha_cita"><i class="fas fa-calendar-alt"></i> Fecha Deseada</label>
          <input type="date" id="fecha_cita" name="fecha_cita" required>
        </div>
        <button type="submit" class="btn-primary btn-block">CONFIRMAR MI RESERVA</button>
      </form>
    </div>
  </div>

  <footer class="vete-footer">
    <p>&copy; 2026 Patitas Felices - Gestión de Citas Online</p>
  </footer>
</body>
</html>
