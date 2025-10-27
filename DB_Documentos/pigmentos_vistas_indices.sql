-- core.v_pigmentos_detalle --

CREATE OR REPLACE VIEW core.v_pigmentos_detalle AS
SELECT 
    p.id AS pigmento_id,
    p.nombre_comercial,
    p.formula_quimica,
    p.numero_ci,
    f.id AS familia_id,
    f.nombre AS familia_nombre,
    f.descripcion AS familia_descripcion,
    c.id AS color_id,
    c.nombre AS color_nombre,
    c.codigo_hexadecimal,
    p.created_at,
    p.updated_at,
    -- Campo calculado para búsquedas rápidas
    (p.nombre_comercial || ' ' || p.formula_quimica || ' ' || p.numero_ci) AS texto_busqueda
FROM core.pigmentos p
JOIN core.familias_quimicas f ON f.id = p.familia_quimica_id
JOIN core.colores c ON c.id = p.color_principal_id;

-- core.v_familias_estadisticas --

CREATE OR REPLACE VIEW core.v_familias_estadisticas AS
SELECT
    f.id AS familia_id,
    f.nombre AS familia_nombre,
    COUNT(p.id) AS total_pigmentos,
    -- Color más frecuente en cada familia
    (
        SELECT c.nombre
        FROM core.pigmentos p2
        JOIN core.colores c ON c.id = p2.color_principal_id
        WHERE p2.familia_quimica_id = f.id
        GROUP BY c.nombre
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS color_mas_frecuente
FROM core.familias_quimicas f
LEFT JOIN core.pigmentos p ON p.familia_quimica_id = f.id
GROUP BY f.id, f.nombre;

-- core.v_colores_estadisticas --

CREATE OR REPLACE VIEW core.v_colores_estadisticas AS
SELECT
    c.id AS color_id,
    c.nombre AS color_nombre,
    c.codigo_hexadecimal,
    COUNT(p.id) AS total_pigmentos,
    -- Familias más comunes por color
    (
        SELECT f.nombre
        FROM core.pigmentos p2
        JOIN core.familias_quimicas f ON f.id = p2.familia_quimica_id
        WHERE p2.color_principal_id = c.id
        GROUP BY f.nombre
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS familia_mas_comun
FROM core.colores c
LEFT JOIN core.pigmentos p ON p.color_principal_id = c.id
GROUP BY c.id, c.nombre, c.codigo_hexadecimal;

-- idices agregados --

-- Índices para FK en pigmentos
CREATE INDEX idx_pigmentos_familia ON core.pigmentos(familia_quimica_id);
CREATE INDEX idx_pigmentos_color ON core.pigmentos(color_principal_id);

-- Índice para búsqueda por número CI (consultas rápidas por código)
CREATE UNIQUE INDEX idx_pigmentos_numero_ci ON core.pigmentos(numero_ci);

-- Índice para búsquedas textuales en vista consolidada
CREATE INDEX idx_pigmentos_texto_busqueda ON core.pigmentos
    USING gin (to_tsvector('spanish', nombre_comercial || ' ' || formula_quimica || ' ' || numero_ci));


