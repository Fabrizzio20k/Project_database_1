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
    duracion_segundos INTEGER NOT NULL,
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
ALTER TABLE Cancion ADD CONSTRAINT CK_Cancion_duracion CHECK (duracion_segundos < 60 AND duracion_minutos < 60 AND duracion_horas < 24);
ALTER TABLE Cancion ADD CONSTRAINT CK_Cancion_min_duracion CHECK (duracion_segundos = 0 AND (duracion_minutos > 0 OR duracion_horas > 0) OR (duracion_segundos > 0 AND duracion_minutos >= 0 AND duracion_horas >= 0));

--Lista_reproduccion
ALTER TABLE Lista_reproduccion ADD CONSTRAINT PK_Lista_reproduccion PRIMARY KEY (nombre, usuario_correo_electronico);
ALTER TABLE Lista_reproduccion ADD CONSTRAINT FK_Lista_reproduccion_usuario FOREIGN KEY (usuario_correo_electronico) REFERENCES Usuario(correo_electronico);

--Lista
ALTER TABLE Lista ADD CONSTRAINT PK_Lista PRIMARY KEY (usuario_correo_electronico, lista_reproduccion_nombre, cancion_nombre, album_nombre, artista_correo_electronico);
ALTER TABLE Lista ADD CONSTRAINT FK_Lista_usuario FOREIGN KEY (usuario_correo_electronico) REFERENCES Usuario(correo_electronico);
ALTER TABLE Lista ADD CONSTRAINT FK_Lista_lista_reproduccion FOREIGN KEY (lista_reproduccion_nombre, usuario_correo_electronico) REFERENCES Lista_reproduccion(nombre, usuario_correo_electronico);
ALTER TABLE Lista ADD CONSTRAINT FK_Lista_cancion_album FOREIGN KEY (cancion_nombre, album_nombre) REFERENCES Cancion(nombre, album_nombre);
ALTER TABLE Lista ADD CONSTRAINT FK_Lista_artista FOREIGN KEY (artista_correo_electronico) REFERENCES Artista(correo_electronico);