SET enable_mergejoin TO OFF;
SET enable_hashjoin TO OFF;
SET enable_bitmapscan TO OFF;
SET enable_sort TO OFF;

SET enable_mergejoin TO ON;
SET enable_hashjoin TO ON;
SET enable_bitmapscan TO ON;
SET enable_sort TO ON;

CREATE INDEX idx_cancion_nombre ON Cancion USING HASH(nombre);
DROP INDEX idx_cancion_nombre;


SELECT genero_nombre, COUNT(genero_nombre) AS cantidad
FROM
    ((Usuario
    JOIN Suscripcion ON Usuario.correo_electronico = Suscripcion.usuario_correo_electronico)
    JOIN Lista ON Usuario.correo_electronico = Lista.usuario_correo_electronico
    JOIN Lista_reproduccion ON Lista.lista_reproduccion_nombre = Lista_reproduccion.nombre AND Lista.usuario_correo_electronico = Lista_reproduccion.usuario_correo_electronico
    JOIN Cancion ON Lista.cancion_nombre = Cancion.nombre AND Lista.album_nombre = Cancion.album_nombre AND Lista.artista_correo_electronico = Cancion.artista_correo_electronico)
    JOIN Genero ON Cancion.genero_nombre = Genero.nombre
WHERE
    Suscripcion.tipo_suscripcion_tipo = 'Premium'
    AND EXTRACT(YEAR FROM AGE(Suscripcion.fecha_fin,Suscripcion.fecha_inicio)) >= 1
    AND EXTRACT(YEAR FROM AGE(CURRENT_DATE,Usuario.fecha_nacimiento)) >= 18
GROUP BY genero_nombre
ORDER BY cantidad DESC
LIMIT 3;