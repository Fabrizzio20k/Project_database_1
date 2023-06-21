/*
--TRIGGER T0 AUTOCOMPLETE THE usuario_correo_electronico, album_nombre AND artista_correo_electronico BASED ON THE cancion_nombre AND lista_reproduccion_nombre ON TABLE Lista

CREATE OR REPLACE FUNCTION set_user_album_artista_lista() RETURNS TRIGGER AS $$
    DECLARE
        user_email VARCHAR(50);
        album_name VARCHAR(20);
        artist_email VARCHAR(50);
    BEGIN
        user_email = (SELECT usuario_correo_electronico FROM Lista_reproduccion WHERE nombre = NEW.lista_reproduccion_nombre ORDER BY RANDOM() LIMIT 1);
        album_name = (SELECT album_nombre FROM Cancion WHERE nombre = NEW.cancion_nombre ORDER BY RANDOM() LIMIT 1);
        artist_email = (SELECT artista_correo_electronico FROM Album WHERE nombre = album_name ORDER BY RANDOM() LIMIT 1);
        NEW.usuario_correo_electronico = user_email;
        NEW.album_nombre = album_name;
        NEW.artista_correo_electronico = artist_email;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_user_album_artista_lista
BEFORE INSERT ON Lista
FOR EACH ROW
EXECUTE PROCEDURE set_user_album_artista_lista();

--SELECT THE EMAIL OF THE ARTIST BEFORE INSERTING A NEW SONG TO AUTOCOMPLETE THE ARTIST EMAIL FIELD BASED ON THE ALBUM NAME

CREATE OR REPLACE FUNCTION set_artist_email() RETURNS TRIGGER AS $$
    DECLARE
        artist_email VARCHAR(50);
    BEGIN
        artist_email = (SELECT Album.artista_correo_electronico FROM Album WHERE nombre = NEW.album_nombre ORDER BY RANDOM() LIMIT 1);
        NEW.artista_correo_electronico = artist_email;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_artist_email
BEFORE INSERT ON Cancion
FOR EACH ROW
EXECUTE PROCEDURE set_artist_email();
*/

--Contar el total de datos por cada tabla

SELECT COUNT(*) FROM Genero; --YA ESTA - 1
SELECT COUNT(*) FROM Tipo_suscripcion; --YA ESTA - 2
SELECT COUNT(*) FROM Usuario; --YA ESTA - 3
SELECT COUNT(*) FROM Suscripcion; --YA ESTA - 4
SELECT COUNT(*) FROM Artista; --YA ESTA - 5
SELECT COUNT(*) FROM Oyentes_artista; --YA ESTA - 6
SELECT COUNT(*) FROM Likes_artista; --YA ESTA - 7
SELECT COUNT(*) FROM Album; --YA ESTA - 8
SELECT COUNT(*) FROM Cancion; --YA ESTA - 9
SELECT COUNT(*) FROM Lista_reproduccion; --YA ESTA - 10
SELECT COUNT(*) FROM Lista; --YA ESTA - 11


--Solo para borrar todas las tablas en orden para no afectar los foreign keys
/*
DROP TABLE Lista;
DROP TABLE Lista_reproduccion;
DROP TABLE Cancion;
DROP TABLE Album;
DROP TABLE Genero;
DROP TABLE Suscripcion;
DROP TABLE Tipo_suscripcion;
DROP TABLE Likes_artista;
DROP TABLE Oyentes_artista;
DROP TABLE Usuario;
DROP TABLE Artista;

DELETE FROM Lista;
DELETE FROM Lista_reproduccion;
DELETE FROM Cancion;
DELETE FROM Album;
DELETE FROM Suscripcion;
DELETE FROM Likes_artista;
DELETE FROM Oyentes_artista;
DELETE FROM Usuario;
DELETE FROM Artista;
*/
