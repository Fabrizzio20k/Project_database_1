CREATE TABLE IF NOT EXISTS Artista(
    correo_electronico VARCHAR(50) NOT NULL, --PRIMARY KEY
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    contrasenia VARCHAR(20) NOT NULL,
    numero_oyentes INTEGER NOT NULL DEFAULT 0,
    numero_likes INTEGER NOT NULL DEFAULT 0,
    is_verificado BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS Usuario(
    correo_electronico VARCHAR(50) NOT NULL, --PRIMARY KEY
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    contrasenia VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS Likes_artista(
    usuario_correo_electronico VARCHAR(50) NOT NULL, --PRIMARY KEY --FOREIGN KEY
    artista_correo_electronico VARCHAR(50) NOT NULL --PRIMARY KEY --FOREIGN KEY
);

CREATE TABLE IF NOT EXISTS Oyentes_artista(
    usuario_correo_electronico VARCHAR(50) NOT NULL, --PRIMARY KEY --FOREIGN KEY
    artista_correo_electronico VARCHAR(50) NOT NULL --PRIMARY KEY --FOREIGN KEY
);

CREATE TABLE IF NOT EXISTS Tipo_suscripcion(
    tipo VARCHAR(20) NOT NULL, --PRIMARY KEY
    precio FLOAT NOT NULL
);

CREATE TABLE IF NOT EXISTS Suscripcion(
    usuario_correo_electronico VARCHAR(50) NOT NULL, --PRIMARY KEY --FOREIGN KEY
    fecha_inicio DATE NOT NULL, --PRIMARY KEY
    fecha_fin DATE NOT NULL, --PRIMARY KEY
    tipo_suscripcion_tipo VARCHAR(20) NOT NULL --FOREIGN KEY
);

CREATE TABLE IF NOT EXISTS Genero(
    nombre VARCHAR(20) NOT NULL --PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS Album(
    nombre VARCHAR(20) NOT NULL, --PRIMARY KEY
    artista_correo_electronico VARCHAR(50) NOT NULL, --PRIMARY KEY --FOREIGN KEY
    fecha_lanzamiento DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS Cancion(
    nombre VARCHAR(20) NOT NULL, --PRIMARY KEY
    album_nombre VARCHAR(20) NOT NULL, --PRIMARY KEY --FOREIGN KEY
    artista_correo_electronico VARCHAR(50), --PRIMARY KEY --FOREIGN KEY
    fecha_lanzamiento DATE NOT NULL,
    genero_nombre VARCHAR(20) NOT NULL, --FOREIGN KEY
    duracion_sec INTEGER NOT NULL,
    duracion_minutos INTEGER NOT NULL,
    duracion_horas INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Lista_reproduccion(
    nombre VARCHAR(20) NOT NULL, --PRIMARY KEY
    usuario_correo_electronico VARCHAR(50) NOT NULL, --PRIMARY KEY --FOREIGN KEY
    duracion INTERVAL NOT NULL DEFAULT '00:00:00'
);

CREATE TABLE IF NOT EXISTS Lista(
    usuario_correo_electronico VARCHAR(50) NOT NULL, --PRIMARY KEY --FOREIGN KEY
    lista_reproduccion_nombre VARCHAR(20) NOT NULL, --PRIMARY KEY --FOREIGN KEY
    cancion_nombre VARCHAR(20) NOT NULL, --PRIMARY KEY --FOREIGN KEY
    album_nombre VARCHAR(20) NOT NULL, --PRIMARY KEY --FOREIGN KEY
    artista_correo_electronico VARCHAR(50) NOT NULL --PRIMARY KEY --FOREIGN KEY
);

--Artista
ALTER TABLE Artista ADD CONSTRAINT PK_Artista PRIMARY KEY (correo_electronico);
ALTER TABLE Artista ADD CONSTRAINT CK_Artista_fecha_nacimiento CHECK (fecha_nacimiento < CURRENT_DATE);

--Usuario
ALTER TABLE Usuario ADD CONSTRAINT PK_Usuario PRIMARY KEY (correo_electronico);
ALTER TABLE Usuario ADD CONSTRAINT CK_Usuario_fecha_nacimiento CHECK (fecha_nacimiento < CURRENT_DATE);

--Likes_artista
ALTER TABLE Likes_artista ADD CONSTRAINT PK_Likes_artista PRIMARY KEY (usuario_correo_electronico, artista_correo_electronico);
ALTER TABLE Likes_artista ADD CONSTRAINT FK_Likes_artista_usuario FOREIGN KEY (usuario_correo_electronico) REFERENCES Usuario(correo_electronico);
ALTER TABLE Likes_artista ADD CONSTRAINT FK_Likes_artista_artista FOREIGN KEY (artista_correo_electronico) REFERENCES Artista(correo_electronico);

--Oyentes_artista
ALTER TABLE Oyentes_artista ADD CONSTRAINT PK_Oyentes_artista PRIMARY KEY (usuario_correo_electronico, artista_correo_electronico);
ALTER TABLE Oyentes_artista ADD CONSTRAINT FK_Oyentes_artista_usuario FOREIGN KEY (usuario_correo_electronico) REFERENCES Usuario(correo_electronico);
ALTER TABLE Oyentes_artista ADD CONSTRAINT FK_Oyentes_artista_artista FOREIGN KEY (artista_correo_electronico) REFERENCES Artista(correo_electronico);

--Tipo_suscripcion
ALTER TABLE Tipo_suscripcion ADD CONSTRAINT PK_Tipo_suscripcion PRIMARY KEY (tipo);

--Suscripcion
ALTER TABLE Suscripcion ADD CONSTRAINT PK_Suscripcion PRIMARY KEY (usuario_correo_electronico, fecha_inicio, fecha_fin);
ALTER TABLE Suscripcion ADD CONSTRAINT FK_Suscripcion_usuario FOREIGN KEY (usuario_correo_electronico) REFERENCES Usuario(correo_electronico);
ALTER TABLE Suscripcion ADD CONSTRAINT FK_Suscripcion_tipo_suscripcion FOREIGN KEY (tipo_suscripcion_tipo) REFERENCES Tipo_suscripcion(tipo);
ALTER TABLE Suscripcion ADD CONSTRAINT CK_Suscripcion_fecha_fin CHECK (fecha_inicio <= fecha_fin);

--Genero
ALTER TABLE Genero ADD CONSTRAINT PK_Genero PRIMARY KEY (nombre);

--Album
ALTER TABLE Album ADD CONSTRAINT PK_Album PRIMARY KEY (nombre, artista_correo_electronico);
ALTER TABLE Album ADD CONSTRAINT FK_Album_artista FOREIGN KEY (artista_correo_electronico) REFERENCES Artista(correo_electronico);

--Cancion
ALTER TABLE Cancion ADD CONSTRAINT PK_Cancion PRIMARY KEY (nombre, album_nombre);
ALTER TABLE Cancion ADD CONSTRAINT FK_Cancion_album FOREIGN KEY (album_nombre, artista_correo_electronico) REFERENCES Album(nombre, artista_correo_electronico);
ALTER TABLE Cancion ADD CONSTRAINT FK_Cancion_genero FOREIGN KEY (genero_nombre) REFERENCES Genero(nombre);
ALTER TABLE Cancion ADD CONSTRAINT CK_Cancion_duracion CHECK (duracion_sec < 60 AND duracion_minutos < 60 AND duracion_horas < 24);
ALTER TABLE Cancion ADD CONSTRAINT CK_Cancion_min_duracion CHECK (duracion_sec = 0 AND (duracion_minutos > 0 OR duracion_horas > 0) OR (duracion_sec > 0 AND duracion_minutos >= 0 AND duracion_horas >= 0));

--Lista_reproduccion
ALTER TABLE Lista_reproduccion ADD CONSTRAINT PK_Lista_reproduccion PRIMARY KEY (nombre, usuario_correo_electronico);
ALTER TABLE Lista_reproduccion ADD CONSTRAINT FK_Lista_reproduccion_usuario FOREIGN KEY (usuario_correo_electronico) REFERENCES Usuario(correo_electronico);

--Lista
ALTER TABLE Lista ADD CONSTRAINT PK_Lista PRIMARY KEY (usuario_correo_electronico, lista_reproduccion_nombre, cancion_nombre, album_nombre, artista_correo_electronico);
ALTER TABLE Lista ADD CONSTRAINT FK_Lista_usuario FOREIGN KEY (usuario_correo_electronico) REFERENCES Usuario(correo_electronico);
ALTER TABLE Lista ADD CONSTRAINT FK_Lista_lista_reproduccion FOREIGN KEY (lista_reproduccion_nombre, usuario_correo_electronico) REFERENCES Lista_reproduccion(nombre, usuario_correo_electronico);
ALTER TABLE Lista ADD CONSTRAINT FK_Lista_cancion_album FOREIGN KEY (cancion_nombre, album_nombre) REFERENCES Cancion(nombre, album_nombre);
ALTER TABLE Lista ADD CONSTRAINT FK_Lista_artista FOREIGN KEY (artista_correo_electronico) REFERENCES Artista(correo_electronico);

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

--TRIGGER TO UPDATE LIKES AND OYENTES FROM ARTIST WHEN A NEW LIKE IS ADDED OR A NEW OYENTE IS ADDED
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

CREATE OR REPLACE FUNCTION update_verificacion_artista() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        --Just modify the status if artist is not verified yet
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

--Update duration from lista_reproduccion when a song is added to the list. Consider that duration for songs are integers, and duration for lists are intervals. You need to calcule first how
--many hours, minutes and seconds are in the song, and then add it to the list duration as an interval

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
            cancion_duracion_segundos = (SELECT duracion_sec FROM Cancion WHERE nombre = NEW.cancion_nombre AND album_nombre = NEW.album_nombre);
            cancion_duracion_total = (cancion_duracion_horas || ' hours')::INTERVAL + (cancion_duracion_minutos || ' minutes')::INTERVAL + (cancion_duracion_segundos || ' seconds')::INTERVAL;
            UPDATE Lista_reproduccion SET duracion = duracion + cancion_duracion_total WHERE nombre = NEW.lista_reproduccion_nombre AND usuario_correo_electronico = NEW.usuario_correo_electronico;
        ELSIF (TG_OP = 'DELETE') THEN
            cancion_duracion_horas = (SELECT duracion_horas FROM Cancion WHERE nombre = OLD.cancion_nombre AND album_nombre = OLD.album_nombre);
            cancion_duracion_minutos = (SELECT duracion_minutos FROM Cancion WHERE nombre = OLD.cancion_nombre AND album_nombre = OLD.album_nombre);
            cancion_duracion_segundos = (SELECT duracion_sec FROM Cancion WHERE nombre = OLD.cancion_nombre AND album_nombre = OLD.album_nombre);
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
SELECT COUNT(*) FROM Lista;

SELECT * FROM Lista;
SELECT * FROM Lista_reproduccion WHERE nombre = 'jumps over the lazy ' AND usuario_correo_electronico = 'tulcvqtoz@tyhcsn.com';
SELECT * FROM Cancion WHERE nombre = 'fox jumps o' AND album_nombre = 'the lazy dogThe quic';

INSERT INTO Lista(lista_reproduccion_nombre, cancion_nombre) VALUES ('jumps over the lazy ', 'fox jumps o');
DELETE FROM Lista;
--Agregar datos al tipo_suscripcion
INSERT INTO Tipo_suscripcion (tipo, precio) VALUES ('Gratis', 0);
INSERT INTO Tipo_suscripcion (tipo, precio) VALUES ('Basic', 15.99);
INSERT INTO Tipo_suscripcion (tipo, precio) VALUES ('Premium', 29.99);
INSERT INTO Tipo_suscripcion (tipo, precio) VALUES ('Ultimate', 39.99);
INSERT INTO Tipo_suscripcion (tipo, precio) VALUES ('Premium Estudiantes', 9.99);

--Agregar datos a genero
INSERT INTO Genero (nombre) VALUES ('Rock');
INSERT INTO Genero (nombre) VALUES ('Pop');
INSERT INTO Genero (nombre) VALUES ('Reggaeton');
INSERT INTO Genero (nombre) VALUES ('Rap');
INSERT INTO Genero (nombre) VALUES ('Electronica');
INSERT INTO Genero (nombre) VALUES ('Clasica');
INSERT INTO Genero (nombre) VALUES ('Jazz');
INSERT INTO Genero (nombre) VALUES ('Metal');
INSERT INTO Genero (nombre) VALUES ('Indie');
INSERT INTO Genero (nombre) VALUES ('Alternativa');
INSERT INTO Genero (nombre) VALUES ('Punk');
INSERT INTO Genero (nombre) VALUES ('Soul');
INSERT INTO Genero (nombre) VALUES ('Folk');
INSERT INTO Genero (nombre) VALUES ('Country');
INSERT INTO Genero (nombre) VALUES ('Reggae');
INSERT INTO Genero (nombre) VALUES ('Blues');
INSERT INTO Genero (nombre) VALUES ('Ska');
INSERT INTO Genero (nombre) VALUES ('Funk');
INSERT INTO Genero (nombre) VALUES ('Disco');
INSERT INTO Genero (nombre) VALUES ('Hip Hop');
INSERT INTO Genero (nombre) VALUES ('R&B');
INSERT INTO Genero (nombre) VALUES ('Infantil');
INSERT INTO Genero (nombre) VALUES ('Otro');


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
*/