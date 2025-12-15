import requests
import pyodbc

# =====================================================
# CONEXIÓN A SQL SERVER
# =====================================================

conn = pyodbc.connect(
    'Driver={SQL Server};'
    'Server=DESKTOP-K8L48DR;'
    'Database=RickAndMortyDB;'
    'Trusted_Connection=yes;'
)

cursor = conn.cursor()
print("Conexión exitosa a SQL Server")


# =====================================================
# 1️⃣ CARGA DE LOCATIONS
# =====================================================

print("Cargando Locations...")

url = "https://rickandmortyapi.com/api/location"

while url:
    data = requests.get(url).json()

    for loc in data["results"]:
        cursor.execute("""
            IF NOT EXISTS (
                SELECT 1 FROM Locations WHERE LocationID = ?
            )
            INSERT INTO Locations (LocationID, Name, Type, Dimension)
            VALUES (?, ?, ?, ?)
        """,
        loc["id"],
        loc["id"],
        loc["name"],
        loc["type"],
        loc["dimension"]
        )

    url = data["info"]["next"]

conn.commit()
print("Locations cargadas correctamente")


# =====================================================
# 2️⃣ CARGA DE EPISODES
# =====================================================

print("Cargando Episodes...")

url = "https://rickandmortyapi.com/api/episode"

while url:
    data = requests.get(url).json()

    for ep in data["results"]:
        cursor.execute("""
            IF NOT EXISTS (
                SELECT 1 FROM Episodes WHERE EpisodeID = ?
            )
            INSERT INTO Episodes (EpisodeID, Name, AirDate, EpisodeCode)
            VALUES (?, ?, ?, ?)
        """,
        ep["id"],
        ep["id"],
        ep["name"],
        ep["air_date"],
        ep["episode"]
        )

    url = data["info"]["next"]

conn.commit()
print("Episodes cargados correctamente")


# =====================================================
# 3️⃣ CARGA DE CHARACTERS
# =====================================================

print("Cargando Characters...")

url = "https://rickandmortyapi.com/api/character"

while url:
    data = requests.get(url).json()

    for c in data["results"]:

        # Obtener IDs de locations (pueden ser NULL)
        origin_id = (
            int(c["origin"]["url"].split("/")[-1])
            if c["origin"]["url"]
            else None
        )

        location_id = (
            int(c["location"]["url"].split("/")[-1])
            if c["location"]["url"]
            else None
        )

        cursor.execute("""
            IF NOT EXISTS (
                SELECT 1 FROM Characters WHERE CharacterID = ?
            )
            INSERT INTO Characters (
                CharacterID,
                Name,
                Status,
                Species,
                Gender,
                OriginLocationID,
                CurrentLocationID
            )
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """,
        c["id"],
        c["id"],
        c["name"],
        c["status"],
        c["species"],
        c["gender"],
        origin_id,
        location_id
        )

    url = data["info"]["next"]

conn.commit()
print("Characters cargados correctamente")


# =====================================================
# 4️⃣ CARGA DE CHARACTER EPISODES (TABLA PUENTE)
# =====================================================

print("Cargando CharacterEpisodes...")

url = "https://rickandmortyapi.com/api/character"

while url:
    data = requests.get(url).json()

    for c in data["results"]:
        character_id = c["id"]

        # Cada personaje aparece en múltiples episodios
        for ep_url in c["episode"]:
            episode_id = int(ep_url.split("/")[-1])

            cursor.execute("""
                IF NOT EXISTS (
                    SELECT 1 FROM CharacterEpisodes
                    WHERE CharacterID = ? AND EpisodeID = ?
                )
                INSERT INTO CharacterEpisodes (CharacterID, EpisodeID)
                VALUES (?, ?)
            """,
            character_id,
            episode_id,
            character_id,
            episode_id
            )

    url = data["info"]["next"]

conn.commit()
print("CharacterEpisodes cargada correctamente")


# =====================================================
# CIERRE DE CONEXIÓN
# =====================================================

cursor.close()
conn.close()

print("ETL finalizado correctamente 🚀")
