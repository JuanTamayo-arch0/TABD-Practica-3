-- Procedimiento: Insertar Color --

CREATE OR REPLACE PROCEDURE core.p_insertar_color(
    p_nombre VARCHAR,
    p_codigo_hexadecimal VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación: nombre no vacío
    IF trim(p_nombre) = '' THEN
        RAISE EXCEPTION 'El nombre no puede estar vacío';
    END IF;

    -- Validación: formato hexadecimal (#RRGGBB)
    IF p_codigo_hexadecimal !~ '^#[0-9A-Fa-f]{6}$' THEN
        RAISE EXCEPTION 'El código hexadecimal debe tener formato válido (#RRGGBB)';
    END IF;

    -- Validación: nombre único
    IF EXISTS (SELECT 1 FROM core.colores WHERE lower(nombre) = lower(p_nombre)) THEN
        RAISE EXCEPTION 'Ya existe un color con el nombre %', p_nombre;
    END IF;

    -- Validación: código único
    IF EXISTS (SELECT 1 FROM core.colores WHERE lower(codigo_hexadecimal) = lower(p_codigo_hexadecimal)) THEN
        RAISE EXCEPTION 'Ya existe un color con el código %', p_codigo_hexadecimal;
    END IF;

    -- Inserción
    INSERT INTO core.colores(id, nombre, codigo_hexadecimal)
    VALUES (gen_random_uuid(), p_nombre, upper(p_codigo_hexadecimal));

END;
$$;

-- Procedimiento: Actualizar Color --

CREATE OR REPLACE PROCEDURE core.p_actualizar_color(
    p_id UUID,
    p_nombre VARCHAR,
    p_codigo_hexadecimal VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación: ID existente
    IF NOT EXISTS (SELECT 1 FROM core.colores WHERE id = p_id) THEN
        RAISE EXCEPTION 'No existe un color con el ID %', p_id;
    END IF;

    -- Validación: nombre no vacío
    IF trim(p_nombre) = '' THEN
        RAISE EXCEPTION 'El nombre no puede estar vacío';
    END IF;

    -- Validación: formato hexadecimal (#RRGGBB)
    IF p_codigo_hexadecimal !~ '^#[0-9A-Fa-f]{6}$' THEN
        RAISE EXCEPTION 'El código hexadecimal debe tener formato válido (#RRGGBB)';
    END IF;

    -- Validación: nombre único en otro ID
    IF EXISTS (
        SELECT 1 FROM core.colores 
        WHERE lower(nombre) = lower(p_nombre) AND id <> p_id
    ) THEN
        RAISE EXCEPTION 'Ya existe otro color con el nombre %', p_nombre;
    END IF;

    -- Validación: código único en otro ID
    IF EXISTS (
        SELECT 1 FROM core.colores 
        WHERE lower(codigo_hexadecimal) = lower(p_codigo_hexadecimal) AND id <> p_id
    ) THEN
        RAISE EXCEPTION 'Ya existe otro color con el código %', p_codigo_hexadecimal;
    END IF;

    -- Actualización
    UPDATE core.colores
    SET nombre = p_nombre,
        codigo_hexadecimal = upper(p_codigo_hexadecimal)
    WHERE id = p_id;

END;
$$;

-- Procedimiento: Eliminar Color--

CREATE OR REPLACE PROCEDURE core.p_eliminar_color(
    p_id UUID
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación: ID existente
    IF NOT EXISTS (SELECT 1 FROM core.colores WHERE id = p_id) THEN
        RAISE EXCEPTION 'No existe un color con el ID %', p_id;
    END IF;

    -- Validación: no debe estar en uso en pigmentos
    IF EXISTS (SELECT 1 FROM core.pigmentos WHERE color_principal_id = p_id) THEN
        RAISE EXCEPTION 'No se puede eliminar el color %, está siendo utilizado en pigmentos', p_id;
    END IF;

    -- Eliminación
    DELETE FROM core.colores WHERE id = p_id;

END;
$$;
