# Sistema de Votación para Reinado ESPE

## Arquitectura del Sistema

El sistema está dividido en tres componentes principales:

### 1. Cliente Móvil (Flutter - `/lib`)
Aplicación móvil desarrollada en Flutter que permite a los usuarios interactuar con el sistema según su rol.

### 2. Servidor Backend (Node.js - `/servidor`)
API REST que maneja toda la lógica de negocio y la comunicación con la base de datos.

### 3. Cliente Web (React - `/client`)
Interfaz web para administración y monitoreo del sistema.

## Roles del Sistema

### 1. Usuario
- Puede registrarse en el sistema
- Puede votar una sola vez por su candidata favorita
- Solo puede votar cuando la votación pública está habilitada
- Puede ver el carrusel de candidatas

### 2. Juez
- Puede calificar a las candidatas en tres eventos:
  - Traje Típico
  - Traje de Gala
  - Preguntas
- Tiene acceso a una interfaz especial para calificación
- Puede modificar sus calificaciones mientras el evento esté activo

### 3. Notario
- Puede monitorear en tiempo real las votaciones
- Tiene acceso a la tabla de control de votos
- Verifica la transparencia del proceso
- No puede emitir votos ni calificaciones

### 4. Administrador
- Gestiona los eventos del concurso
- Puede:
  - Iniciar/cerrar eventos
  - Reiniciar votaciones
  - Cerrar votaciones
  - Generar reportes
- Monitorea el progreso de las votaciones
- Gestiona usuarios y candidatas

### 5. Super Administrador
- Tiene todos los permisos del administrador
- Puede:
  - Gestionar roles y permisos
  - Gestionar eventos
  - Gestionar usuarios
  - Gestionar candidatas
- Acceso completo al sistema

## Etapas del Concurso

### 1. Traje Típico
- Primera etapa de calificación
- Solo los jueces pueden calificar
- Se evalúa la presentación del traje típico

### 2. Traje de Gala
- Segunda etapa de calificación
- Solo los jueces pueden calificar
- Se evalúa la presentación del traje de gala

### 3. Preguntas
- Tercera etapa de calificación
- Solo los jueces pueden calificar
- Se evalúan las respuestas a preguntas específicas

### 4. Votación Pública
- Cuarta etapa
- Se habilita solo después de que todos los jueces hayan calificado
- Los usuarios registrados pueden votar una sola vez
- Contribuye al puntaje final de las candidatas

### 5. Desempate (si es necesario)
- Etapa especial en caso de empate
- Solo se activa si hay un empate en los puntajes finales
- Los jueces realizan una votación adicional

## Funcionalidades Principales

### Gestión de Candidatas
- Registro de candidatas con:
  - Datos personales
  - Carrera
  - Departamento
  - Fotografías
- Visualización en carrusel
- Sistema de calificación

### Sistema de Votación
- Calificación de jueces (eventos 1-3)
- Votación pública (evento 4)
- Sistema de desempate
- Prevención de votos duplicados

### Gestión de Eventos
- Control de inicio/fin de cada etapa
- Monitoreo en tiempo real
- Sistema de puntajes
- Generación de reportes

### Seguridad
- Autenticación de usuarios
- Control de acceso basado en roles
- Tokens JWT para sesiones
- Validación de datos

## Base de Datos

### Tablas Principales
- users: Gestión de usuarios y roles
- candidata: Información de candidatas
- calificacion: Registro de calificaciones
- evento: Control de etapas
- votaciones_publico: Registro de votos públicos

## Características Técnicas

### Cliente Móvil (Flutter)
- Interfaz responsiva
- Gestión de estado con Provider
- Diseño material con tema personalizado
- Manejo de imágenes y assets

### Servidor (Node.js)
- API REST
- Autenticación JWT
- Validación de datos
- Manejo de errores
- Conexión a MySQL

### Cliente Web (React)
- Panel de administración
- Monitoreo en tiempo real
- Interfaz de usuario moderna
- Gestión de estado con Context API
