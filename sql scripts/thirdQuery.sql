SET enable_mergejoin TO OFF;
SET enable_hashjoin TO OFF;
SET enable_bitmapscan TO OFF;
SET enable_sort TO OFF;

SET enable_mergejoin TO ON;
SET enable_hashjoin TO ON;
SET enable_bitmapscan TO ON;
SET enable_sort TO ON;

CREATE INDEX idx_cancion_fecha_lanzamiento ON Cancion USING BTREE(fecha_lanzamiento);
DROP INDEX idx_cancion_fecha_lanzamiento;

SELECT s.tipo_suscripcion_tipo, COUNT(*) AS cantidad
FROM Suscripcion s
JOIN (
    SELECT DISTINCT l.usuario_correo_electronico
    FROM Lista l
    JOIN (
        SELECT c.nombre, c.album_nombre, c.artista_correo_electronico
        FROM Cancion c
        JOIN Album a ON c.album_nombre = a.nombre AND c.artista_correo_electronico = a.artista_correo_electronico
        JOIN Artista ar ON a.artista_correo_electronico = ar.correo_electronico
        JOIN Lista l ON c.nombre = l.cancion_nombre AND c.album_nombre = l.album_nombre AND c.artista_correo_electronico = l.artista_correo_electronico
        WHERE ar.is_verificado = TRUE AND c.fecha_lanzamiento < '2021-01-01'
        GROUP BY c.nombre, c.album_nombre, c.artista_correo_electronico
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS CancionMasAgregada ON l.cancion_nombre = CancionMasAgregada.nombre AND l.album_nombre = CancionMasAgregada.album_nombre AND l.artista_correo_electronico = CancionMasAgregada.artista_correo_electronico
) AS UsuariosConCancion ON s.usuario_correo_electronico = UsuariosConCancion.usuario_correo_electronico
GROUP BY s.tipo_suscripcion_tipo
ORDER BY cantidad DESC
LIMIT 1;
