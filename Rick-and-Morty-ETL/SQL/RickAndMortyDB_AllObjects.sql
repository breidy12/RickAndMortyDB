USE RickAndMortyDB
GO

-- =========================================================
-- 1️⃣ Listar todos los personajes
-- Muestra el nombre, estado y especie de todos los personajes
-- =========================================================
SELECT Name, Status, Species
FROM Characters;
GO

-- =========================================================
-- 2️⃣ Listar personajes vivos
-- Filtra los personajes cuyo estado sea 'Alive'
-- =========================================================
SELECT Name, Status
FROM Characters
WHERE Status = 'Alive';
GO

-- =========================================================
-- 3️⃣ Listar episodios de un personaje específico
-- Muestra todos los episodios en los que aparece Rick Sanchez
-- =========================================================
SELECT e.EpisodeID,
       e.Name AS EpisodeName,
       e.EpisodeCode,
       e.AirDate
FROM Characters c
JOIN CharacterEpisodes ce ON c.CharacterID = ce.CharacterID
JOIN Episodes e ON ce.EpisodeID = e.EpisodeID
WHERE c.Name = 'Rick Sanchez';
GO

-- =========================================================
-- 4️⃣ Contar personajes por ubicación
-- Muestra cuántos personajes hay en cada ubicación actual
-- =========================================================
SELECT l.Name AS LocationName,
       COUNT(*) AS NumCharacters
FROM Characters c
JOIN Locations l ON c.CurrentLocationID = l.LocationID
GROUP BY l.Name;
GO

-- =========================================================
-- 5️⃣ Listar personajes por especie
-- Filtra los personajes de la especie 'Human'
-- =========================================================
SELECT Name
FROM Characters
WHERE Species = 'Human';
GO

-- =========================================================
-- 6️⃣ Listar personajes por género
-- Filtra los personajes de género masculino
-- =========================================================
SELECT Name, Gender
FROM Characters
WHERE Gender = 'Male';
GO

-- =========================================================
-- 7️⃣ Listar ubicaciones con personajes vivos
-- Muestra todas las ubicaciones y solo los personajes vivos en ellas
-- =========================================================
SELECT l.Name AS LocationName, c.Name AS CharacterName
FROM Characters c
JOIN Locations l ON c.CurrentLocationID = l.LocationID
WHERE c.Status = 'Alive'
ORDER BY l.Name;
GO

-- =========================================================
-- 8️⃣ Contar episodios por personaje
-- Muestra cuántos episodios tiene cada personaje
-- =========================================================
SELECT c.Name AS CharacterName, COUNT(ce.EpisodeID) AS NumEpisodes
FROM Characters c
JOIN CharacterEpisodes ce ON c.CharacterID = ce.CharacterID
GROUP BY c.Name;
GO

-- =========================================================
-- 9️⃣ Listar personajes que aparecen en un episodio específico
-- Por ejemplo, el episodio con EpisodeCode 'S01E01'
-- =========================================================
SELECT c.Name AS CharacterName, e.Name AS EpisodeName
FROM Characters c
JOIN CharacterEpisodes ce ON c.CharacterID = ce.CharacterID
JOIN Episodes e ON ce.EpisodeID = e.EpisodeID
WHERE e.EpisodeCode = 'S01E01';
GO

-- =========================================================
-- 🔟 Listar personajes y su ubicación de origen y actual
-- Muestra el personaje, su ubicación de origen y su ubicación actual
-- =========================================================
SELECT c.Name AS CharacterName,
       l1.Name AS OriginLocation,
       l2.Name AS CurrentLocation
FROM Characters c
LEFT JOIN Locations l1 ON c.OriginLocationID = l1.LocationID
LEFT JOIN Locations l2 ON c.CurrentLocationID = l2.LocationID;
GO

-- =========================================================
-- 1️⃣1️⃣ Crear Vistas
-- =========================================================

-- Vista 1: Personajes con su ubicación actual
CREATE VIEW vw_CharactersWithCurrentLocation AS
SELECT c.Name AS CharacterName,
       c.Status,
       c.Species,
       l.Name AS CurrentLocation
FROM Characters c
JOIN Locations l ON c.CurrentLocationID = l.LocationID;
GO

-- Vista 2: Episodios con número de personajes
CREATE VIEW vw_EpisodesCharacterCount AS
SELECT e.EpisodeID,
       e.Name AS EpisodeName,
       COUNT(ce.CharacterID) AS NumCharacters
FROM Episodes e
JOIN CharacterEpisodes ce ON e.EpisodeID = ce.EpisodeID
GROUP BY e.EpisodeID, e.Name;
GO

-- =========================================================
-- 1️⃣2️⃣ Procedimientos almacenados
-- =========================================================

-- Procedimiento 1: Listar personajes por especie
CREATE PROCEDURE sp_GetCharactersBySpecies
    @Species NVARCHAR(50)
AS
BEGIN
    SELECT Name, Status, Gender
    FROM Characters
    WHERE Species = @Species;
END;
GO

-- Procedimiento 2: Contar personajes por ubicación
CREATE PROCEDURE sp_CountCharactersByLocation
AS
BEGIN
    SELECT l.Name AS LocationName, COUNT(*) AS NumCharacters
    FROM Characters c
    JOIN Locations l ON c.CurrentLocationID = l.LocationID
    GROUP BY l.Name;
END;
GO

-- =========================================================
-- 1️⃣3️⃣ Triggers
-- =========================================================

-- Trigger 1: Evitar insertar personajes sin ubicación actual
CREATE TRIGGER trg_Characters_Insert
ON Characters
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE CurrentLocationID IS NULL)
    BEGIN
        RAISERROR('No se puede insertar un personaje sin ubicación actual.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger 2: Notificación al insertar o eliminar de CharacterEpisodes
CREATE TRIGGER trg_UpdateCharacterEpisodes
ON CharacterEpisodes
AFTER INSERT, DELETE
AS
BEGIN
    PRINT 'Se modificó la relación personaje-episodio. Recuerda actualizar los conteos si es necesario.';
END;
GO

-- =========================================================
-- FIN DEL SCRIPT
