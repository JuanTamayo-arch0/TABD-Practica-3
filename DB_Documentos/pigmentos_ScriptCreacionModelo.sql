-- =====================================================================================================================
-- SISTEMA DE GESTIÓN DE PIGMENTOS INORGÁNICOS PARA PROCESOS ARTÍSTICOS
-- =====================================================================================================================
--
-- PROYECTO:    API REST para Gestión de Pigmentos Inorgánicos - Implementación del Modelo de Datos
-- UNIVERSIDAD: Universidad Pontificia Bolivariana
-- CURSO:       Tópicos Avanzados de Base de Datos - Examen No. 3
-- FECHA:       Septiembre 2025
-- VERSION:     1.0
--
-- DESCRIPCIÓN:
-- Este script implementa el modelo de datos normalizado para la gestión de pigmentos inorgánicos
-- utilizados en procesos artísticos. El modelo está diseñado para soportar una API REST que
-- implemente el patrón repositorio con operaciones CRUD completas.
--
-- FUENTE DE DATOS:
-- Especificaciones del Examen No. 3 - Patrón Repositorio
-- Sistema de información para pigmentos inorgánicos artísticos
-- Colour Index International (CII) - Estándar internacional de pigmentos
--
-- CARACTERÍSTICAS DEL MODELO:
-- - Normalización en Tercera Forma Normal (3FN)
-- - Uso exclusivo de UUIDs para claves primarias y foráneas
-- - Integridad referencial garantizada con restricciones CASCADE/RESTRICT
-- - Optimización para consultas analíticas y operaciones CRUD
-- - Separación de responsabilidades entre entidades maestras y transaccionales
-- - Índices específicos para optimización de rendimiento de la API
--
-- =====================================================================================================================

-- =====================================================================================================================
-- SECCIÓN 1: CREACIÓN DE TABLAS MAESTRAS (CATÁLOGOS)
-- =====================================================================================================================
--
-- Las tablas maestras contienen información de referencia que es utilizada por las entidades
-- principales del sistema. Estas tablas implementan catálogos normalizados que eliminan
-- redundancias y garantizan consistencia en la clasificación de pigmentos.
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TABLA MAESTRA: core.colores
-- PROPÓSITO: Catálogo de colores principales para clasificación cromática de pigmentos inorgánicos
-- RELACIONES: Referenciada por core.pigmentos (1:N)
-- CARACTERÍSTICAS: 
--   - Catálogo maestro con restricciones de unicidad estrictas
--   - Validación de formato hexadecimal para representación digital
--   - Campos de auditoría para trazabilidad de cambios
-- ---------------------------------------------------------------------------------------------------------------------

CREATE TABLE core.colores (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    codigo_hexadecimal VARCHAR(7) NOT NULL,
    
    -- Restricciones de unicidad para integridad de catálogo
    CONSTRAINT uq_colores_nombre UNIQUE (nombre),
    CONSTRAINT uq_colores_codigo_hex UNIQUE (codigo_hexadecimal),
    
    -- Validaciones de formato y contenido
    CONSTRAINT chk_colores_nombre_valido CHECK (LENGTH(TRIM(nombre)) > 0),
    CONSTRAINT chk_colores_codigo_hex_formato CHECK (codigo_hexadecimal ~ '^#[0-9A-Fa-f]{6}$')
);

COMMENT ON TABLE core.colores IS 'Catálogo maestro de colores principales utilizados para la clasificación cromática de pigmentos inorgánicos en procesos artísticos';
COMMENT ON COLUMN core.colores.id IS 'Identificador único del color generado automáticamente como UUID';
COMMENT ON COLUMN core.colores.nombre IS 'Nombre descriptivo del color (ej: Azul, Rojo, Verde). Debe ser único en el catálogo';
COMMENT ON COLUMN core.colores.codigo_hexadecimal IS 'Código de color hexadecimal para representación digital en formato #RRGGBB (ej: #0F4C75)';


-- ---------------------------------------------------------------------------------------------------------------------
-- TABLA MAESTRA: core.familias_quimicas
-- PROPÓSITO: Catálogo de familias químicas que clasifican pigmentos por composición molecular
-- RELACIONES: Referenciada por core.pigmentos (1:N)
-- CARACTERÍSTICAS:
--   - Clasificación basada en estructura molecular y composición química
--   - Descripción detallada para soporte técnico y académico
--   - Base para análisis comparativos entre pigmentos de la misma familia
-- ---------------------------------------------------------------------------------------------------------------------

CREATE TABLE core.familias_quimicas (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Restricciones de unicidad y validación
    CONSTRAINT uq_familias_nombre UNIQUE (nombre),
    CONSTRAINT chk_familias_nombre_valido CHECK (LENGTH(TRIM(nombre)) > 0)
);

COMMENT ON TABLE core.familias_quimicas IS 'Catálogo maestro de familias químicas que clasifican los pigmentos inorgánicos según su composición molecular y estructura química';
COMMENT ON COLUMN core.familias_quimicas.id IS 'Identificador único de la familia química generado automáticamente como UUID';
COMMENT ON COLUMN core.familias_quimicas.nombre IS 'Nombre de la familia química (ej: Óxidos, Sulfatos, Cromatos, Carbonatos). Debe ser único';
COMMENT ON COLUMN core.familias_quimicas.descripcion IS 'Descripción detallada de las características químicas, propiedades moleculares y comportamiento de los pigmentos de esta familia';

-- =====================================================================================================================
-- SECCIÓN 2: CREACIÓN DE TABLA PRINCIPAL (ENTIDAD TRANSACCIONAL)
-- =====================================================================================================================
--
-- La tabla principal contiene los registros de pigmentos inorgánicos con todas sus propiedades
-- específicas. Esta tabla implementa las relaciones con las tablas maestras mediante claves
-- foráneas y contiene la información detallada de cada pigmento individual.
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TABLA PRINCIPAL: core.pigmentos
-- PROPÓSITO: Registro principal de pigmentos inorgánicos utilizados en procesos artísticos
-- RELACIONES: 
--   - Relaciona con core.familias_quimicas (N:1)
--   - Relaciona con core.colores (N:1)
-- CARACTERÍSTICAS:
--   - Entidad central del modelo con información completa de cada pigmento
--   - Implementa estándar Color Index International (CII)
--   - Validaciones específicas para nomenclatura química y comercial
--   - Restricciones de integridad referencial con políticas diferenciadas
-- ---------------------------------------------------------------------------------------------------------------------

CREATE TABLE core.pigmentos (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nombre_comercial VARCHAR(200) NOT NULL,
    formula_quimica VARCHAR(100) NOT NULL,
    numero_ci VARCHAR(20) NOT NULL,
    familia_quimica_id UUID NOT NULL,
    color_principal_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Claves foráneas con políticas de integridad diferenciadas
    CONSTRAINT fk_pigmentos_familia_quimica FOREIGN KEY (familia_quimica_id) 
        REFERENCES core.familias_quimicas(id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pigmentos_color_principal FOREIGN KEY (color_principal_id) 
        REFERENCES core.colores(id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Restricciones de unicidad para evitar duplicados
    CONSTRAINT uq_pigmentos_nombre_comercial UNIQUE (nombre_comercial),
    CONSTRAINT uq_pigmentos_numero_ci UNIQUE (numero_ci),
    
    -- Validaciones de contenido y formato
    CONSTRAINT chk_pigmentos_nombre_comercial_valido CHECK (LENGTH(TRIM(nombre_comercial)) > 0),
    CONSTRAINT chk_pigmentos_formula_quimica_valida CHECK (LENGTH(TRIM(formula_quimica)) > 0)
);

COMMENT ON TABLE core.pigmentos IS 'Registro principal de pigmentos inorgánicos utilizados en procesos artísticos, incluyendo propiedades químicas, comerciales y clasificaciones estándar';
COMMENT ON COLUMN core.pigmentos.id IS 'Identificador único del pigmento generado automáticamente como UUID';
COMMENT ON COLUMN core.pigmentos.nombre_comercial IS 'Nombre comercial del pigmento utilizado en el mercado artístico (ej: Azul Cobalto, Rojo Cadmio)';
COMMENT ON COLUMN core.pigmentos.formula_quimica IS 'Fórmula química del compuesto inorgánico usando nomenclatura estándar (ej: CoO·Al₂O₃, CdS)';
COMMENT ON COLUMN core.pigmentos.numero_ci IS 'Número del Color Index International (CII) - identificador estándar internacional (ej: PB28, PR108)';
COMMENT ON COLUMN core.pigmentos.familia_quimica_id IS 'Referencia UUID a la familia química a la que pertenece el pigmento';
COMMENT ON COLUMN core.pigmentos.color_principal_id IS 'Referencia UUID al color principal que caracteriza visualmente al pigmento';

-- =====================================================================================================================
-- SECCIÓN 3: POBLACIÓN DE DATOS DE PRUEBA 
-- =====================================================================================================================
--
-- Inserción de 5 pigmentos representativos según los requerimientos del examen, seleccionados
-- para demostrar la diversidad del catálogo y permitir consultas cruzadas efectivas entre
-- entidades. Los pigmentos incluyen ejemplos históricos y modernos de diferentes familias químicas.
-- =====================================================================================================================

-- Poblacion tabla "colores"

INSERT INTO core.colores (nombre, codigo_hexadecimal) VALUES
('Azul', '#0F4C75'),
('Rojo', '#C70039'),
('Amarillo', '#FFC300'),
('Verde', '#4F7942'),
('Blanco', '#FFFFFF'),
('Negro', '#1C1C1C'),
('Naranja', '#FF5733'),
('Violeta', '#8E44AD'),
('Marrón', '#8B4513'),
('Gris', '#808080');

-- Poblacion tabla "Familias_Químicas"

INSERT INTO core.familias_quimicas (nombre, descripcion) VALUES
('Óxidos', 'Compuestos inorgánicos formados por la combinación de un elemento con oxígeno'),
('Sulfuros', 'Compuestos químicos binarios del azufre con elementos menos electronegativos'),
('Cromatos', 'Sales del ácido crómico que contienen el anión cromato CrO₄²⁻'),
('Ferrocianuros', 'Compuestos que contienen el anión ferrocianuro [Fe(CN)₆]⁴⁻'),
('Carbonatos', 'Sales derivadas del ácido carbónico que contienen el anión CO₃²⁻'),
('Silicatos', 'Compuestos que contienen aniones de silicio y oxígeno en diversas formas'),
('Titanatos', 'Compuestos que contienen el ion titanato TiO₃²⁻'),
('Fosfatos', 'Sales derivadas del ácido fosfórico que contienen el anión PO₄³⁻');

-- Poblacion tabla "Pigmentos"

INSERT INTO core.pigmentos (nombre_comercial, formula_quimica, numero_ci, familia_quimica_id, color_principal_id)
SELECT
    datos.nombre_comercial,
    datos.formula_quimica,
    datos.numero_ci,
    f.id as familia_quimica_id,
    c.id as color_principal_id
FROM (
    VALUES
    ('Azul Cobalto', 'CoO·Al₂O₃', 'PB28', 'Óxidos', 'Azul'),
    ('Azul Ultramar', 'Na₈₁₀Al₆Si₆S₄', 'PB29', 'Silicatos', 'Azul'),
    ('Azul de Prusia', 'Fe₄[Fe(CN)₆]₃', 'PB27', 'Ferrocianuros', 'Azul'),
    ('Rojo Cadmio', 'CdSe', 'PR108', 'Sulfuros', 'Rojo'),
    ('Óxido de Hierro Rojo', 'Fe₂O₃', 'PR101', 'Óxidos', 'Rojo'),
    ('Rojo Cromo', 'PbCrO₄·PbO', 'PR104', 'Cromatos', 'Rojo'),
    ('Amarillo Cadmio Claro', 'CdS', 'PY35', 'Sulfuros', 'Amarillo'),
    ('Amarillo Cromo', 'PbCrO₄', 'PY34', 'Cromatos', 'Amarillo'),
    ('Amarillo de Nápoles', 'Pb₃(SbO₄)₂', 'PY41', 'Óxidos', 'Amarillo'),
    ('Verde Óxido de Cromo', 'Cr₂O₃', 'PG17', 'Óxidos', 'Verde'),
    ('Verde Esmeralda', 'Cu(C₂H₃O₂)₂·3Cu(AsO₂)₂', 'PG21', 'Óxidos', 'Verde'),
    ('Blanco de Titanio', 'TiO₂', 'PW6', 'Óxidos', 'Blanco'),
    ('Blanco de Zinc', 'ZnO', 'PW4', 'Óxidos', 'Blanco'),
    ('Negro de Hueso', 'Ca₃(PO₄)₂ + C', 'PBk9', 'Fosfatos', 'Negro'),
    ('Negro de Hierro', 'Fe₃O₄', 'PBk11', 'Óxidos', 'Negro'),
    ('Naranja de Cadmio', 'Cd(S,Se)', 'PO20', 'Sulfuros', 'Naranja'),
    ('Violeta de Manganeso', 'Mn₃(PO₄)₂', 'PV16', 'Fosfatos', 'Violeta'),
    ('Tierra de Siena Natural', 'Fe₂O₃·nH₂O + MnO₂ + Al₂O₃ + SiO₂', 'PBr7', 'Óxidos', 'Marrón'),
    ('Tierra de Sombra', 'Fe₂O₃ + MnO₂ + SiO₂ + Al₂O₃', 'PBr8', 'Óxidos', 'Marrón'),
    ('Gris Payne', 'Fe₄[Fe(CN)₆]₃ + TiO₂', 'PBk21', 'Ferrocianuros', 'Gris')
) AS datos(nombre_comercial, formula_quimica, numero_ci, familia_nombre, color_nombre)
JOIN core.familias_quimicas f ON f.nombre = datos.familia_nombre
JOIN core.colores c ON c.nombre = datos.color_nombre;


-- =====================================================================================================================
-- FIN DE LA IMPLEMENTACIÓN DEL MODELO DE DATOS
-- =====================================================================================================================