-- Procedimiento: Insertar Pigmento --

CREATE OR REPLACE PROCEDURE core.p_insertar_pigmento(
    p_nombre_comercial VARCHAR,
    p_formula_quimica  VARCHAR,
    p_numero_ci        VARCHAR,
    p_familia_id       UUID,
    p_color_id         UUID
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación: nombre comercial y fórmula química no vacíos
    IF trim(p_nombre_comercial) = '' THEN
        RAISE EXCEPTION 'El nombre comercial no puede estar vacío';
    END IF;
    IF trim(p_formula_quimica) = '' THEN
        RAISE EXCEPTION 'La fórmula química no puede estar vacía';
    END IF;

    -- Validación: formato número CI (ej. PR108, PB28)
    IF p_numero_ci !~ '^[A-Z]{1,2}[0-9]{1,3}$' THEN
        RAISE EXCEPTION 'El número CI % no tiene formato válido (ej. PR108, PB28)', p_numero_ci;
    END IF;

    -- Validación: unicidad de nombre comercial y número CI
    IF EXISTS (SELECT 1 FROM core.pigmentos WHERE lower(nombre_comercial) = lower(p_nombre_comercial)) THEN
        RAISE EXCEPTION 'Ya existe un pigmento con el nombre comercial %', p_nombre_comercial;
    END IF;
    IF EXISTS (SELECT 1 FROM core.pigmentos WHERE upper(numero_ci) = upper(p_numero_ci)) THEN
        RAISE EXCEPTION 'Ya existe un pigmento con el número CI %', p_numero_ci;
    END IF;

    -- Validación: familia química y color existen
    IF NOT EXISTS (SELECT 1 FROM core.familias_quimicas WHERE id = p_familia_id) THEN
        RAISE EXCEPTION 'No existe familia química con ID %', p_familia_id;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM core.colores WHERE id = p_color_id) THEN
        RAISE EXCEPTION 'No existe color con ID %', p_color_id;
    END IF;

    -- Inserción
    INSERT INTO core.pigmentos(id, nombre_comercial, formula_quimica, numero_ci, familia_quimica_id, color_principal_id, created_at, updated_at)
    VALUES (gen_random_uuid(), p_nombre_comercial, p_formula_quimica, upper(p_numero_ci), p_familia_id, p_color_id, NOW(), NOW());

END;
$$;

-- Procedimiento: Actualizar Pigmento --

CREATE OR REPLACE PROCEDURE core.p_actualizar_pigmento(
    p_id              UUID,
    p_nombre_comercial VARCHAR,
    p_formula_quimica  VARCHAR,
    p_numero_ci        VARCHAR,
    p_familia_id       UUID,
    p_color_id         UUID
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación: ID existente
    IF NOT EXISTS (SELECT 1 FROM core.pigmentos WHERE id = p_id) THEN
        RAISE EXCEPTION 'No existe un pigmento con el ID %', p_id;
    END IF;

    -- Validación: nombre y fórmula no vacíos
    IF trim(p_nombre_comercial) = '' THEN
        RAISE EXCEPTION 'El nombre comercial no puede estar vacío';
    END IF;
    IF trim(p_formula_quimica) = '' THEN
        RAISE EXCEPTION 'La fórmula química no puede estar vacía';
    END IF;

    -- Validación: formato número CI
    IF p_numero_ci !~ '^[A-Z]{1,2}[0-9]{1,3}$' THEN
        RAISE EXCEPTION 'El número CI % no tiene formato válido (ej. PR108, PB28)', p_numero_ci;
    END IF;

    -- Validación: unicidad de nombre y número CI en otros registros
    IF EXISTS (
        SELECT 1 FROM core.pigmentos WHERE lower(nombre_comercial) = lower(p_nombre_comercial) AND id <> p_id
    ) THEN
        RAISE EXCEPTION 'Ya existe otro pigmento con el nombre comercial %', p_nombre_comercial;
    END IF;

    IF EXISTS (
        SELECT 1 FROM core.pigmentos WHERE upper(numero_ci) = upper(p_numero_ci) AND id <> p_id
    ) THEN
        RAISE EXCEPTION 'Ya existe otro pigmento con el número CI %', p_numero_ci;
    END IF;

    -- Validación: familia química y color existen
    IF NOT EXISTS (SELECT 1 FROM core.familias_quimicas WHERE id = p_familia_id) THEN
        RAISE EXCEPTION 'No existe familia química con ID %', p_familia_id;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM core.colores WHERE id = p_color_id) THEN
        RAISE EXCEPTION 'No existe color con ID %', p_color_id;
    END IF;

    -- Actualización
    UPDATE core.pigmentos
    SET nombre_comercial = p_nombre_comercial,
        formula_quimica  = p_formula_quimica,
        numero_ci        = upper(p_numero_ci),
        familia_quimica_id = p_familia_id,
        color_principal_id = p_color_id,
        updated_at = NOW()
    WHERE id = p_id;

END;
$$;

-- Procedimiento: Eliminar Pigmento --

CREATE OR REPLACE PROCEDURE core.p_eliminar_pigmento(
    p_id UUID
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación: ID existente
    IF NOT EXISTS (SELECT 1 FROM core.pigmentos WHERE id = p_id) THEN
        RAISE EXCEPTION 'No existe un pigmento con el ID %', p_id;
    END IF;

    -- Eliminación
    DELETE FROM core.pigmentos WHERE id = p_id;

END;
$$;

