# RickAndMortyDB

Proyecto de base de datos SQL basado en la API de **Rick and Morty**, que incluye **tablas con datos**, **vistas**, **procedimientos almacenados**, **triggers** y un **script ETL en Python** para cargar datos desde la API oficial.

---

## 📂 Estructura del proyecto

Rick-and-Morty-ETL/
│
├─ SQL/
│ ├─ RickAndMortyDB.sql
│ └─ RickAndMortyDB_AllObjects.sql
│
├─ ETL/
│ └─ ETL_Rick_and_Morty.py
│
└─ README.md


---

## 🗃️ Scripts SQL

### 1️⃣ `RickAndMortyDB.sql`
- Crea la base de datos y tablas principales:
  - `Locations`, `Episodes`, `Characters`, `CharacterEpisodes`
- Inserta datos iniciales.

### 2️⃣ `RickAndMortyDB_AllObjects.sql`
- Contiene:
  - **Vistas**
  - **Procedimientos almacenados**
  - **Triggers**
- Administra relaciones entre personajes, episodios y ubicaciones.

---

## 🐍 Script ETL

### `ETL/ETL_Rick_and_Morty.py`
- Conecta con SQL Server usando `pyodbc`.
- Descarga datos desde la API oficial usando `requests`.
- Inserta datos en:
  - `Locations`
  - `Episodes`
  - `Characters`
  - `CharacterEpisodes`
- Maneja relaciones y evita duplicados.
- Cierra la conexión al finalizar.

---

## ⚡ Cómo ejecutar el proyecto

1. Abrir **SQL Server Management Studio (SSMS)**.
2. Ejecutar **`SQL/RickAndMortyDB.sql`** para crear la base de datos y tablas con datos.
3. Ejecutar **`SQL/RickAndMortyDB_AllObjects.sql`** para crear vistas, procedimientos y triggers.
4. (Opcional) Ejecutar **`ETL/ETL_Rick_and_Morty.py`** para sincronizar datos desde la API.
5. Consultar vistas y procedimientos según se necesite.

---

## 📌 Buenas prácticas

- Mantener los scripts SQL en `SQL/` y los scripts Python en `ETL/`.
- Documentar cada procedimiento o vista si se agregan nuevas consultas.
- Hacer commits claros al subir a GitHub:
  - "Agregar estructura de BD y tablas"
  - "Agregar vistas, procedimientos y triggers"
  - "Agregar script ETL"
  - "Actualizar documentación"

---

## 📝 Notas

- Nivel recomendado: **básico sólido de SQL y Python**.
- Proyecto expandible con más vistas, procedimientos o integración de APIs.
- Ideal para mostrar conocimientos de bases de datos relacionales y ETL en Python en GitHub.

---

## ✅ Resultado esperado

- Base de datos `RickAndMortyDB` con todas las tablas pobladas.
- Vistas y procedimientos funcionales.
- Triggers activándose automáticamente según su definición.
- Script ETL capaz de sincronizar datos desde la API oficial.
