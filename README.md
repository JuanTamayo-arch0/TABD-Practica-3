# Inorganic Pigments API 🎨

![.NET](https://img.shields.io/badge/.NET-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![C#](https://img.shields.io/badge/C%23-239120?style=for-the-badge&logo=c-sharp&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)

## 🎯 Project Description

This repository contains the complete implementation of a **REST API** for managing inorganic pigments used in artistic processes. The project is developed as a practical exercise for the **Advanced Database Topics** course, implementing the **repository pattern** with layered separation and focusing on providing centralized and structured access to specialized information about pigments, their chemical families, and chromatic properties.

### 🚀 Objective

Develop a robust REST API that allows:
- Complete management of the inorganic pigments catalog
- Queries by chemical and chromatic classification
- Identification using the Color Index International (CII) standard
- Comparative analysis of properties for artistic decision-making
- Programmatic access for third-party applications

---

## 👥 Development Team

### 👨‍💻 Members

| Student | ID | Institutional Email | Role |
|---------|----|--------------------|------|
| **Juan Jose Tamayo Ospina** | 000193632 | juanjose.tamayo@upb.edu.co | DEVELOPER |
| **Daniel Cardona Gonzalez** | 000414882 | daniel.cardonag.col@upb.edu.co | DEVELOPER |

### 🏫 Academic Information
- **University:** Universidad Pontificia Bolivariana
- **Program:** Systems and Computer Engineering
- **Course:** Advanced Database Topics
- **NRC:** 30286, 30578
- **Period:** 2025-2
- **Delivery Date:** September 24, 2025

---

## 🏗️ System Architecture

### Layer Structure

```
Controllers → Services → Repositories (via Interfaces) → DB Context
                  ↓
              IRepositories (Interfaces)
```

### 📋 Main Components
- **Controllers** - Presentation layer and HTTP request handling
- **Services** - Business logic and domain rule validations
- **Interfaces** - Contracts for repository decoupling
- **Repositories** - Data access implementations and CRUD operations
- **Entities** - Domain models for pigments, families, and colors
- **Data** - Database contexts and configurations

## 🗃️ Data Model

The system implements a **normalized relational model** with the following entities:

### 🎨 Main Entities

#### Pigments
Main registry of inorganic pigments for art

- `Id` (UUID) - Unique identifier
- `NombreComercial` (TEXT) - Commercial name of the pigment
- `FormulaQuimica` (TEXT) - Chemical formula of the compound
- `NumeroCi` (TEXT) - Color Index International (worldwide standard)
- `FamiliaQuimicaId` (UUID) - Reference to chemical family
- `ColorPrincipalId` (UUID) - Reference to main color

#### Chemical Families
Classification by chemical composition

- `Id` (UUID) - Unique identifier
- `Nombre` (TEXT) - Name of the chemical family
- `Descripcion` (TEXT) - Detailed description of properties

#### Colors
Chromatic catalog with digital representation

- `Id` (UUID) - Unique identifier
- `Nombre` (TEXT) - Color name
- `CodigoHexadecimal` (TEXT) - Hex code for digital representation

### 📊 Sample Data

| Pigment | Formula | CI Code | Family | Color | Hex |
|---------|---------|---------|--------|-------|-----|
| Cobalt Blue | CoO·Al₂O₃ | PB28 | Oxides | Blue | #0F4C75 |

---

## 🛠️ Technology Stack

| Technology | Version | Purpose |
|-----------|---------|---------|
| **.NET** | 8.x | Main development framework |
| **C#** | 12.0 | Programming language |
| **PostgreSQL** | 12+ | Database management system |
| **Swagger/OpenAPI** | 3.0 | Interactive API documentation |
| **UUID/GUID** | - | Secure identifiers |
| **Git** | 2.0+ | Version control |

---

## 🌐 API Endpoints

### 🎨 Pigments
```http
GET    /api/pigmentos                        # 📋 List all pigments
GET    /api/pigmentos/{pigmento_id}          # 🔍 Get specific pigment
POST   /api/pigmentos                        # ➕ Create new pigment
PUT    /api/pigmentos                        # ✏️ Update pigment
DELETE /api/pigmentos/{pigmento_id}          # 🗑️ Delete pigment
```

### 🧪 Chemical Families
```http
GET    /api/familias                         # 📋 List all families
GET    /api/familias/{familia_id}            # 🔍 Get specific family
GET    /api/familias/{familia_id}/pigmentos  # 🎨 Pigments by family
```

### 🌈 Colors
```http
GET    /api/colores                          # 📋 List all colors
GET    /api/colores/{color_id}               # 🔍 Get specific color
GET    /api/colores/{color_id}/pigmentos     # 🎨 Pigments by color
POST   /api/colores                          # ➕ Create new color
PUT    /api/colores                          # ✏️ Update color
DELETE /api/colores/{color_id}               # 🗑️ Delete color
```

**Total: 14 implemented endpoints** ✅

---

## ⚙️ Technical Implementation

### 📖 Read Operations (SELECT)
Queries use **optimized SQL statements** for maximum performance

### ✍️ Write Operations (CUD)
Implemented through **stored procedures** for:
- ✅ Ensuring data integrity
- 🔒 Security in critical operations
- 📈 Transaction optimization

### 🛡️ Business Validations
- Valid Color Index code format
- Consistency in FK relationships
- Hexadecimal code validation
- Uniqueness in commercial identifiers

---

## 🚀 Installation and Usage

### 📋 Prerequisites
- .NET 8.x SDK
- PostgreSQL 12+
- Git

### 🔧 Quick Setup
```bash
# Clone repository
git clone [REPOSITORY_URL]

# Configure database
# Update connection string in appsettings.json

# Restore dependencies
dotnet restore

# Run application
dotnet run
```

### 📚 Interactive Documentation
Once running, access:
```
https://localhost:5001/swagger
```

---

## 🎖️ Academic Objectives

- ✅ **Repository Pattern**: Complete and functional implementation
- ✅ **Layer Separation**: Clean and maintainable architecture
- ✅ **Decoupling**: Interfaces for flexibility
- ✅ **Best Practices**: UUIDs, stored procedures
- ✅ **Specialized Domain**: Knowledge of the artistic sector

---

## 📜 Project Notes

This project is developed for academic purposes at Universidad Pontificia Bolivariana. Information about pigments is based on international Color Index standards and specialized art literature.

---

**Developed in September 2025**

**Universidad Pontificia Bolivariana - Medellín, Colombia** 🇨🇴
