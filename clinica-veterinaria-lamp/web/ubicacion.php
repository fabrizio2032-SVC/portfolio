<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="estilos.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <title>Ubicación | Patitas Felices</title>
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
      <a href="ubicacion.php" class="active">Madrid</a>
      <a href="registro.php" class="btn-primary">Registrar Caso</a>
    </nav>
  </header>

  <section class="vete-section vete-hero" style="background-image: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('https://images.unsplash.com/photo-1539037116277-4db20889f2d4?auto=format&fit=crop&w=1400&q=80');">
    <div class="vete-hero-content">
      <h1>NOS UBICAMOS EN MADRID</h1>
      <p>En el corazón de la capital, listos para atender a tus compañeros 24/7.</p>
    </div>
  </section>

  <div class="vete-container-main">
    <section class="ubicacion-grid card-luxe">
      <div class="mapa-fake">
        <img src="https://images.unsplash.com/photo-1543783232-260175081b0c?auto=format&fit=crop&w=800&q=80" alt="Mapa de Madrid">
        <div class="pin-mapa"><i class="fas fa-map-marker-alt fa-3x"></i></div>
      </div>
      <div class="info-contacto">
        <h2>¿Dónde encontrarnos?</h2>
        <p><i class="fas fa-map-marked-alt"></i> <strong>Dirección:</strong> Paseo de la Castellana 150, Chamartín, 28046 Madrid, España.</p>
        <p><i class="fas fa-phone-alt"></i> <strong>Urgencias:</strong> +34 912 345 678</p>
        <p><i class="fas fa-envelope"></i> <strong>Email:</strong> contacto@patitasfelices.es</p>
        <a href="https://www.google.com/maps/search/?api=1&query=Paseo+de+la+Castellana+150+Madrid" target="_blank" rel="noopener" class="btn-maps">ABRIR EN GOOGLE MAPS</a>
      </div>
    </section>

    <section class="horarios-section card-luxe">
      <h2><i class="far fa-clock"></i> Horarios de Atención</h2>
      <div class="horarios-lista">
        <div class="dia"><span>Lunes a Viernes:</span> <strong>09:00 - 21:00</strong></div>
        <div class="dia"><span>Sábados:</span> <strong>10:00 - 14:00</strong></div>
        <div class="dia"><span>Urgencias 24h:</span> <strong class="vete-accent">Abierto 365 días</strong></div>
      </div>
    </section>
  </div>

  <footer class="vete-footer">
    <p>&copy; 2026 Patitas Felices - Ubicados en el corazón de Madrid</p>
  </footer>
</body>
</html>
