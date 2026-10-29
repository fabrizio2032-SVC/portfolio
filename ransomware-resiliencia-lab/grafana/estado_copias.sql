-- Panel "Estado de copias": última copia correcta por sistema y su antigüedad.
-- Umbral rojo a partir de 26 horas (RPO objetivo: 24 h).
SELECT s.nombre,
       max(c.fin) AS ultima_ok,
       round(extract(epoch FROM (now() - max(c.fin))) / 3600, 1) AS horas
FROM sistemas s
LEFT JOIN copias c ON c.sistema_id = s.id AND c.estado IN ('OK', 'VERIFICADA')
GROUP BY s.nombre
ORDER BY horas DESC;
