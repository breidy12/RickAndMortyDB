-- =========================================================
-- Base de datos: RickAndMortyDB
-- Descripción:
-- Modelo relacional basado en la API de Rick and Morty.
-- Incluye personajes, episodios, ubicaciones y sus relaciones.
-- =========================================================

USE RickAndMortyDB;
GO

-- =========================================================
-- Tabla: Locations
-- Almacena las ubicaciones del universo Rick and Morty
-- =========================================================
CREATE TABLE Locations (
    LocationID INT PRIMARY KEY,      -- ID único de la ubicación (API)
    Name NVARCHAR(100),               -- Nombre de la ubicación
    Type NVARCHAR(50),                -- Tipo (Planet, Space station, etc.)
    Dimension NVARCHAR(50)            -- Dimensión a la que pertenece
);

-- =========================================================
-- Tabla: Episodes
-- Almacena los episodios de la serie
-- =========================================================
CREATE TABLE Episodes (
    EpisodeID INT PRIMARY KEY,        -- ID único del episodio (API)
    Name NVARCHAR(100),               -- Nombre del episodio
    AirDate NVARCHAR(50),             -- Fecha de emisión
    EpisodeCode NVARCHAR(20)          -- Código del episodio (Ej: S01E01)
);

-- =========================================================
-- Tabla: Characters
-- Almacena los personajes principales
-- =========================================================
CREATE TABLE Characters (
    CharacterID INT PRIMARY KEY,      -- ID único del personaje (API)
    Name NVARCHAR(100),               -- Nombre del personaje
    Status NVARCHAR(50),              -- Estado (Alive, Dead, Unknown)
    Species NVARCHAR(50),             -- Especie
    Gender NVARCHAR(20),              -- Género

    -- Relaciones con ubicaciones
    OriginLocationID INT,             -- Ubicación de origen
    CurrentLocationID INT,            -- Ubicación actual

    -- Llaves foráneas hacia Locations
    FOREIGN KEY (OriginLocationID) REFERENCES Locations(LocationID),
    FOREIGN KEY (CurrentLocationID) REFERENCES Locations(LocationID)
);

-- =========================================================
-- Tabla: CharacterEpisodes
-- Tabla intermedia (muchos a muchos)
-- Relaciona personajes con episodios
-- =========================================================
CREATE TABLE CharacterEpisodes (
    CharacterID INT,                  -- ID del personaje
    EpisodeID INT,                    -- ID del episodio

    -- Llave primaria compuesta
    PRIMARY KEY (CharacterID, EpisodeID),

    -- Llaves foráneas
    FOREIGN KEY (CharacterID) REFERENCES Characters(CharacterID),
    FOREIGN KEY (EpisodeID) REFERENCES Episodes(EpisodeID)
);
GO
-- =========================================================

SELECT * FROM Locations
WHERE LocationID = 1;
GO
-- =========================================================