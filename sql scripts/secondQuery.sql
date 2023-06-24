SET enable_mergejoin TO OFF;
SET enable_hashjoin TO OFF;
SET enable_bitmapscan TO OFF;
SET enable_sort TO OFF;

SET enable_mergejoin TO ON;
SET enable_hashjoin TO ON;
SET enable_bitmapscan TO ON;
SET enable_sort TO ON;

CREATE INDEX idx_artista_numero_oyentes ON Artista USING BTREE(numero_oyentes);
DROP INDEX idx_artista_numero_oyentes;

WITH artistas_max_oyentes AS (
    SELECT correo_electronico
    FROM Artista
    WHERE numero_oyentes = (SELECT MAX(numero_oyentes) FROM Artista WHERE Artista.is_verificado = TRUE)
),
canciones_artistas_max_oyentes AS (
    SELECT nombre, album_nombre, artista_correo_electronico
    FROM Cancion
    JOIN artistas_max_oyentes ON Cancion.artista_correo_electronico = artistas_max_oyentes.correo_electronico
),
listas_artistas_max_oyentes AS (
    SELECT usuario_correo_electronico, lista_reproduccion_nombre, cancion_nombre, Lista.artista_correo_electronico
    FROM Lista
    JOIN canciones_artistas_max_oyentes ON Lista.artista_correo_electronico = canciones_artistas_max_oyentes.artista_correo_electronico
),
conteo_listas_artistas_max_oyentes AS (
    SELECT usuario_correo_electronico, artista_correo_electronico, COUNT(artista_correo_electronico) AS conteo
    FROM listas_artistas_max_oyentes
    GROUP BY usuario_correo_electronico, artista_correo_electronico
),
max_conteo_listas_artistas_max_oyentes AS (
    SELECT MAX(conteo) AS max_conteo
    FROM conteo_listas_artistas_max_oyentes
),
usuarios_conteo_maximo AS (
    SELECT correo_electronico, EXTRACT(YEAR FROM AGE(CURRENT_DATE,Usuario.fecha_nacimiento)) AS edad, conteo
    FROM Usuario
    JOIN conteo_listas_artistas_max_oyentes ON Usuario.correo_electronico = conteo_listas_artistas_max_oyentes.usuario_correo_electronico
    JOIN max_conteo_listas_artistas_max_oyentes ON conteo_listas_artistas_max_oyentes.conteo = max_conteo_listas_artistas_max_oyentes.max_conteo
)
SELECT edad, sum(conteo) as conteo_total, tipo_suscripcion_tipo
FROM Suscripcion
JOIN usuarios_conteo_maximo ON usuarios_conteo_maximo.correo_electronico = Suscripcion.usuario_correo_electronico
GROUP BY edad, tipo_suscripcion_tipo;