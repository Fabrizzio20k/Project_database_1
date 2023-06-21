--TRIGGER TO UPDATE LIKES FROM ARTIST WHEN A NEW LIKE IS ADDED OR A NEW OYENTE IS ADDED

CREATE OR REPLACE FUNCTION update_likes_artista() RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            UPDATE Artista SET numero_likes = numero_likes + 1 WHERE correo_electronico = NEW.artista_correo_electronico;
        ELSIF (TG_OP = 'DELETE') THEN
            UPDATE Artista SET numero_likes = numero_likes - 1 WHERE correo_electronico = OLD.artista_correo_electronico;
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_likes_artista
AFTER INSERT OR DELETE ON Likes_artista
FOR EACH ROW
EXECUTE PROCEDURE update_likes_artista();

--TRIGGER TO UPDATE OYENTES FROM ARTIST WHEN A NEW LIKE IS ADDED OR A NEW OYENTE IS ADDED

CREATE OR REPLACE FUNCTION update_oyentes_artista() RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            UPDATE Artista SET numero_oyentes = numero_oyentes + 1 WHERE correo_electronico = NEW.artista_correo_electronico;
        ELSIF (TG_OP = 'DELETE') THEN
            UPDATE Artista SET numero_oyentes = numero_oyentes - 1 WHERE correo_electronico = OLD.artista_correo_electronico;
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_oyentes_artista
AFTER INSERT OR DELETE ON Oyentes_artista
FOR EACH ROW
EXECUTE PROCEDURE update_oyentes_artista();

--TRIGGER TO UPDATE VERIFIED STATUS OF AN ARTIST WHEN A NEW SONG IS ADDED OR A SONG IS DELETED

CREATE OR REPLACE FUNCTION update_verificacion_artista() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        IF (SELECT is_verificado FROM Artista WHERE correo_electronico = NEW.artista_correo_electronico) = FALSE THEN
            UPDATE Artista SET is_verificado = TRUE WHERE correo_electronico = NEW.artista_correo_electronico;
        END IF;
    ELSIF (TG_OP = 'DELETE') THEN
        IF (SELECT COUNT(*) FROM Cancion WHERE artista_correo_electronico = OLD.artista_correo_electronico) = 0 THEN
            UPDATE Artista SET is_verificado = FALSE WHERE correo_electronico = OLD.artista_correo_electronico;
        END IF;
    END IF;
    IF (TG_OP = 'DELETE') THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_verificacion_artista
AFTER INSERT OR DELETE ON Cancion
FOR EACH ROW
EXECUTE PROCEDURE update_verificacion_artista();

--UPDATE DURATION FROM LISTA_REPRODUCCION WHEN A SONG IS ADDED TO THE LIST OR DELETED FROM THE LIST

CREATE OR REPLACE FUNCTION update_duration_lista_reproduccion() RETURNS TRIGGER AS $$
    DECLARE
        cancion_duracion_horas INT;
        cancion_duracion_minutos INT;
        cancion_duracion_segundos INT;
        cancion_duracion_total INTERVAL;
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            cancion_duracion_horas = (SELECT duracion_horas FROM Cancion WHERE nombre = NEW.cancion_nombre AND album_nombre = NEW.album_nombre);
            cancion_duracion_minutos = (SELECT duracion_minutos FROM Cancion WHERE nombre = NEW.cancion_nombre AND album_nombre = NEW.album_nombre);
            cancion_duracion_segundos = (SELECT duracion_segundos FROM Cancion WHERE nombre = NEW.cancion_nombre AND album_nombre = NEW.album_nombre);
            cancion_duracion_total = (cancion_duracion_horas || ' hours')::INTERVAL + (cancion_duracion_minutos || ' minutes')::INTERVAL + (cancion_duracion_segundos || ' seconds')::INTERVAL;
            UPDATE Lista_reproduccion SET duracion = duracion + cancion_duracion_total WHERE nombre = NEW.lista_reproduccion_nombre AND usuario_correo_electronico = NEW.usuario_correo_electronico;
        ELSIF (TG_OP = 'DELETE') THEN
            cancion_duracion_horas = (SELECT duracion_horas FROM Cancion WHERE nombre = OLD.cancion_nombre AND album_nombre = OLD.album_nombre);
            cancion_duracion_minutos = (SELECT duracion_minutos FROM Cancion WHERE nombre = OLD.cancion_nombre AND album_nombre = OLD.album_nombre);
            cancion_duracion_segundos = (SELECT duracion_segundos FROM Cancion WHERE nombre = OLD.cancion_nombre AND album_nombre = OLD.album_nombre);
            cancion_duracion_total = (cancion_duracion_horas || ' hours')::INTERVAL + (cancion_duracion_minutos || ' minutes')::INTERVAL + (cancion_duracion_segundos || ' seconds')::INTERVAL;
            UPDATE Lista_reproduccion SET duracion = duracion - cancion_duracion_total WHERE nombre = OLD.lista_reproduccion_nombre AND usuario_correo_electronico = OLD.usuario_correo_electronico;
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_duration_lista_reproduccion
AFTER INSERT OR DELETE ON Lista
FOR EACH ROW
EXECUTE PROCEDURE update_duration_lista_reproduccion();