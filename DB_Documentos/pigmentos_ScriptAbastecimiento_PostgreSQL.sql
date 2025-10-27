-- =====================================================================================================================
-- SISTEMA DE GESTIÓN DE PIGMENTOS INORGÁNICOS PARA PROCESOS ARTÍSTICOS
-- =====================================================================================================================
--
-- PROYECTO:    API REST para Gestión de Pigmentos Inorgánicos
-- CURSO:       Tópicos Avanzados de Base de Datos - Examen No. 3
-- UNIVERSIDAD: Universidad Pontificia Bolivariana
-- FECHA:       Septiembre 2025
-- VERSION:     1.0
--
-- DESCRIPCIÓN:
-- Este script implementa la infraestructura de base de datos PostgreSQL para el proyecto
-- de API REST de pigmentos inorgánicos. Incluye configuración para Azure Container Instances,
-- creación de usuarios con privilegios específicos y modelo de datos normalizado.
--
-- CARACTERÍSTICAS DEL MODELO:
-- - Normalización en Tercera Forma Normal (3FN)
-- - Uso de UUIDs para todas las claves primarias y foráneas
-- - Integridad referencial garantizada
-- - Separación de privilegios entre usuarios de aplicación y desarrollo
-- - Optimización para operaciones CRUD y procedimientos almacenados
--
-- =====================================================================================================================

-- =====================================================================================================================
-- SECCIÓN 0: CONFIGURACIÓN INICIAL PARA AZURE CONTAINER INSTANCES
-- =====================================================================================================================
--
-- Esta sección configura el entorno de base de datos optimizado para Azure Container Instances,
-- incluyendo la creación de usuarios con privilegios específicos según las especificaciones:
-- - pigmentos_app: Usuario para implementación del modelo de datos (DDL)
-- - pigmentos_usr: Usuario para operaciones CRUD y ejecución de procedimientos (DML)
--
-- NOTA: Ejecutar como superusuario (postgres)
-- =====================================================================================================================

-- Crear la base de datos principal
CREATE DATABASE pigmentos_db;

-- Conectar a la base de datos creada
\c pigmentos_db;

-- Activar la extensión que permite el uso de UUID
create extension if not exists "uuid-ossp";

-- =====================================================================================================================
-- CREACIÓN DE ESQUEMA Y USUARIOS
-- =====================================================================================================================

-- Crear esquema principal para el modelo de datos
CREATE SCHEMA IF NOT EXISTS core;

-- Usuario para desarrollo/implementación del modelo (DDL privileges)
CREATE USER pigmentos_app WITH 
    ENCRYPTED PASSWORD '**********';

-- Usuario para la aplicación (DML privileges)  
CREATE USER pigmentos_usr WITH 
    ENCRYPTED PASSWORD '**********';

-- =====================================================================================================================
-- CONFIGURACIÓN DE PRIVILEGIOS - USUARIO pigmentos_app (DESARROLLO)
-- =====================================================================================================================

-- Privilegios de conexión
GRANT CONNECT ON DATABASE pigmentos_db TO pigmentos_app;
GRANT TEMPORARY ON DATABASE pigmentos_db TO pigmentos_app;

-- Privilegios sobre el esquema core
GRANT CREATE ON SCHEMA core TO pigmentos_app;
GRANT USAGE ON SCHEMA core TO pigmentos_app;
GRANT ALL PRIVILEGES ON SCHEMA core TO pigmentos_app;

-- Privilegios sobre objetos existentes y futuros
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA core TO pigmentos_app;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA core TO pigmentos_app;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA core TO pigmentos_app;
GRANT ALL PRIVILEGES ON ALL PROCEDURES IN SCHEMA core TO pigmentos_app;

-- Privilegios por defecto para objetos futuros
ALTER DEFAULT PRIVILEGES IN SCHEMA core 
    GRANT ALL PRIVILEGES ON TABLES TO pigmentos_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA core 
    GRANT ALL PRIVILEGES ON SEQUENCES TO pigmentos_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA core 
    GRANT ALL PRIVILEGES ON FUNCTIONS TO pigmentos_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA core 
    GRANT ALL PRIVILEGES ON PROCEDURES TO pigmentos_app;

-- =====================================================================================================================
-- CONFIGURACIÓN DE PRIVILEGIOS - USUARIO pigmentos_usr (APLICACIÓN)
-- =====================================================================================================================

-- Privilegios de conexión
GRANT CONNECT ON DATABASE pigmentos_db TO pigmentos_usr;
GRANT TEMPORARY ON DATABASE pigmentos_db TO pigmentos_usr;

-- Privilegios de uso del esquema
GRANT USAGE ON SCHEMA core TO pigmentos_usr;

-- Privilegios CRUD sobre tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA core TO pigmentos_usr;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA core TO pigmentos_usr;

-- Privilegios para ejecutar funciones y procedimientos almacenados
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA core TO pigmentos_usr;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA core TO pigmentos_usr;

-- Privilegios por defecto para objetos futuros
ALTER DEFAULT PRIVILEGES IN SCHEMA core 
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO pigmentos_usr;
ALTER DEFAULT PRIVILEGES IN SCHEMA core 
    GRANT USAGE, SELECT ON SEQUENCES TO pigmentos_usr;
ALTER DEFAULT PRIVILEGES IN SCHEMA core 
    GRANT EXECUTE ON FUNCTIONS TO pigmentos_usr;
ALTER DEFAULT PRIVILEGES IN SCHEMA core 
    GRANT EXECUTE ON PROCEDURES TO pigmentos_usr;

