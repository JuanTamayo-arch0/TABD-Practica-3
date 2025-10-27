# API Pigmentos Inorgánicos 🎨

![.NET](https://img.shields.io/badge/.NET-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![C#](https://img.shields.io/badge/C%23-239120?style=for-the-badge&logo=c-sharp&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)

## 🎯 Descripción del Proyecto

Este repositorio contiene la implementación completa de una **API REST** para la gestión de pigmentos inorgánicos utilizados en procesos artísticos. El proyecto está desarrollado como ejercicio práctico para el curso de **Tópicos Avanzados de Bases de Datos**, implementando el **patrón repositorio** con separación por capas y enfocándose en proporcionar acceso centralizado y estructurado a información especializada sobre pigmentos, sus familias químicas y propiedades cromáticas.

### 🚀 Objetivo

Desarrollar una API REST robusta que permita:
- Gestión completa del catálogo de pigmentos inorgánicos
- Consultas por clasificación química y cromática
- Identificación mediante estándar Color Index International (CII)
- Análisis comparativo de propiedades para toma de decisiones artísticas
- Acceso programático para aplicaciones de terceros

---

## 👥 Equipo de Desarrollo

### 👨‍💻 Integrantes

| Estudiante | ID | Correo Institucional | Rol |
|------------|----|--------------------|-----|
| **Juan Jose Tamayo Ospina** | 000193632 | juanjose.tamayo@upb.edu.co | DESARROLLADOR |
| **Daniel Cardona Gonzalez** | 000414882 | daniel.cardonag.col@upb.edu.co | DESARROLLADOR |

### 🏫 Información Académica
- **Universidad:** Universidad Pontificia Bolivariana
- **Programa:** Ingeniería en Sistemas e Informática
- **Materia:** Tópicos Avanzados de Bases de Datos
- **NRC:** 30286, 30578
- **Período:** 2025-2
- **Fecha de Entrega:** 24 de septiembre de 2025

---

## 🏗️ Arquitectura del Sistema

### Estructura de Capas

```
Controllers → Services → Repositories (via Interfaces) → DB Context
                  ↓
              IRepositories (Interfaces)
```

### 📋 Componentes Principales
- **Controllers** - Capa de presentación y manejo de peticiones HTTP
- **Services** - Lógica de negocio y validaciones de reglas de dominio
- **Interfaces** - Contratos para desacoplamiento de repositorios
- **Repositories** - Implementaciones de acceso a datos y operaciones CRUD
- **Entities** - Modelos de dominio de pigmentos, familias y colores
- **Data** - Contextos y configuraciones de base de datos

## 🗃️ Modelo de Datos

El sistema implementa un **modelo relacional normalizado** con las siguientes entidades:

### 🎨 Entidades Principales

#### Pigmentos
Registro principal de pigmentos inorgánicos para arte

- `Id` (UUID) - Identificador único
- `NombreComercial` (TEXT) - Nombre comercial del pigmento
- `FormulaQuimica` (TEXT) - Fórmula química del compuesto
- `NumeroCi` (TEXT) - Color Index International (estándar mundial)
- `FamiliaQuimicaId` (UUID) - Referencia a familia química
- `ColorPrincipalId` (UUID) - Referencia al color principal

#### Familias Químicas
Clasificación por composición química

- `Id` (UUID) - Identificador único
- `Nombre` (TEXT) - Nombre de la familia química
- `Descripcion` (TEXT) - Descripción detallada de propiedades

#### Colores
Catálogo cromático con representación digital

- `Id` (UUID) - Identificador único
- `Nombre` (TEXT) - Nombre del color
- `CodigoHexadecimal` (TEXT) - Código hex para representación digital

### 📊 Datos de Ejemplo

| Pigmento | Fórmula | Código CI | Familia | Color | Hex |
|----------|---------|-----------|---------|-------|-----|
| Azul Cobalto | CoO·Al₂O₃ | PB28 | Óxidos | Azul | #0F4C75 |

---

## 🛠️ Stack Tecnológico

| Tecnología | Versión | Propósito |
|-----------|---------|-----------|
| **.NET** | 8.x | Framework principal de desarrollo |
| **C#** | 12.0 | Lenguaje de programación |
| **PostgreSQL** | 12+ | Sistema de gestión de base de datos |
| **Swagger/OpenAPI** | 3.0 | Documentación interactiva de API |
| **UUID/GUID** | - | Identificadores seguros |
| **Git** | 2.0+ | Control de versiones |

---

## 🌐 Endpoints de la API

### 🎨 Pigmentos
```http
GET    /api/pigmentos                        # 📋 Listar todos los pigmentos
GET    /api/pigmentos/{pigmento_id}          # 🔍 Obtener pigmento específico
POST   /api/pigmentos                        # ➕ Crear nuevo pigmento
PUT    /api/pigmentos                        # ✏️ Actualizar pigmento
DELETE /api/pigmentos/{pigmento_id}          # 🗑️ Eliminar pigmento
```

### 🧪 Familias Químicas
```http
GET    /api/familias                         # 📋 Listar todas las familias
GET    /api/familias/{familia_id}            # 🔍 Obtener familia específica
GET    /api/familias/{familia_id}/pigmentos  # 🎨 Pigmentos por familia
```

### 🌈 Colores
```http
GET    /api/colores                          # 📋 Listar todos los colores
GET    /api/colores/{color_id}               # 🔍 Obtener color específico
GET    /api/colores/{color_id}/pigmentos     # 🎨 Pigmentos por color
POST   /api/colores                          # ➕ Crear nuevo color
PUT    /api/colores                          # ✏️ Actualizar color
DELETE /api/colores/{color_id}               # 🗑️ Eliminar color
```

**Total: 14 endpoints implementados** ✅

---

## ⚙️ Implementación Técnica

### 📖 Operaciones de Lectura (SELECT)
Las consultas utilizan **sentencias SQL optimizadas** para máximo rendimiento

### ✍️ Operaciones de Escritura (CUD)
Implementadas mediante **procedimientos almacenados** para:
- ✅ Garantizar integridad de datos
- 🔒 Seguridad en operaciones críticas
- 📈 Optimización de transacciones

### 🛡️ Validaciones de Negocio
- Formato válido de códigos Color Index
- Consistencia en relaciones FK
- Validación de códigos hexadecimales
- Unicidad en identificadores comerciales

---

## 🚀 Instalación y Uso

### 📋 Prerrequisitos
- .NET 8.x SDK
- PostgreSQL 12+
- Git

### 🔧 Configuración Rápida
```bash
# Clonar repositorio
git clone [URL_REPOSITORIO]

# Configurar base de datos
# Actualizar connection string en appsettings.json

# Restaurar dependencias
dotnet restore

# Ejecutar aplicación
dotnet run
```

### 📚 Documentación Interactiva
Una vez ejecutado, accede a:
```
https://localhost:5001/swagger
```

---

## 🎖️ Objetivos Académicos

- ✅ **Patrón Repositorio**: Implementación completa y funcional
- ✅ **Separación de Capas**: Arquitectura limpia y mantenible  
- ✅ **Desacoplamiento**: Interfaces para flexibilidad
- ✅ **Mejores Prácticas**: UUIDs, procedimientos almacenados
- ✅ **Dominio Especializado**: Conocimiento del sector artístico

---

## 📜 Notas del Proyecto

Este proyecto es desarrollado con fines académicos para la Universidad Pontificia Bolivariana. La información sobre pigmentos se basa en estándares internacionales del Color Index y literatura especializada en arte.

---

**Desarrollado en Septiembre 2025**

**Universidad Pontificia Bolivariana - Medellín, Colombia** 🇨🇴
