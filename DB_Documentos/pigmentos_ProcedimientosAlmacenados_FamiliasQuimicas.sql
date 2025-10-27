-- Procedimiento: Insertar Familia Química --

CREATE OR REPLACE PROCEDURE core.p_insertar_familia_quimica(
    p_nombre VARCHAR,
    p_descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación: nombre no vacío
    IF trim(p_nombre) = '' THEN
        RAISE EXCEPTION 'El nombre no puede estar vacío';
    END IF;

    -- Validación: descripción mínima de 10 caracteres
    IF length(trim(p_descripcion)) < 10 THEN
        RAISE EXCEPTION 'La descripción debe tener al menos 10 caracteres';
    END IF;

    -- Validación: nombre único
    IF EXISTS (SELECT 1 FROM core.familias_quimicas WHERE lower(nombre) = lower(p_nombre)) THEN
        RAISE EXCEPTION 'Ya existe una familia química con el nombre %', p_nombre;
    END IF;

    -- Inserción
    INSERT INTO core.familias_quimicas(id, nombre, descripcion, created_at, updated_at)
    VALUES (gen_random_uuid(), p_nombre, p_descripcion, NOW(), NOW());

END;
$$;

-- Procedimiento: Actualizar Familia Química --

CREATE OR REPLACE PROCEDURE core.p_actualizar_familia_quimica(
    p_id UUID,
    p_nombre VARCHAR,
    p_descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación: ID existente
    IF NOT EXISTS (SELECT 1 FROM core.familias_quimicas WHERE id = p_id) THEN
        RAISE EXCEPTION 'No existe una familia química con el ID %', p_id;
    END IF;

    -- Validación: nombre no vacío
    IF trim(p_nombre) = '' THEN
        RAISE EXCEPTION 'El nombre no puede estar vacío';
    END IF;

    -- Validación: descripción mínima de 10 caracteres
    IF length(trim(p_descripcion)) < 10 THEN
        RAISE EXCEPTION 'La descripción debe tener al menos 10 caracteres';
    END IF;

    -- Validación: nombre único en otro ID
    IF EXISTS (
        SELECT 1 FROM core.familias_quimicas 
        WHERE lower(nombre) = lower(p_nombre) AND id <> p_id
    ) THEN
        RAISE EXCEPTION 'Ya existe otra familia química con el nombre %', p_nombre;
    END IF;

    -- Actualización
    UPDATE core.familias_quimicas
    SET nombre = p_nombre,
        descripcion = p_descripcion,
        updated_at = NOW()
    WHERE id = p_id;

END;
$$;

-- Procedimiento: Eliminar Familia Química --

CREATE OR REPLACE PROCEDURE core.p_eliminar_familia_quimica(
    p_id UUID
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación: ID existente
    IF NOT EXISTS (SELECT 1 FROM core.familias_quimicas WHERE id = p_id) THEN
        RAISE EXCEPTION 'No existe una familia química con el ID %', p_id;
    END IF;

    -- Validación: no debe estar en uso en pigmentos
    IF EXISTS (SELECT 1 FROM core.pigmentos WHERE familia_quimica_id = p_id) THEN
        RAISE EXCEPTION 'No se puede eliminar la familia química %, está siendo utilizada en pigmentos', p_id;
    END IF;

    -- Eliminación
    DELETE FROM core.familias_quimicas WHERE id = p_id;

END;
$$;
