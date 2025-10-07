# Documentación: Optimización de Imágenes Docker

## 🎯 Actividad 1: Optimización de Imágenes Docker

### Objetivo
Crear imágenes más pequeñas y eficientes utilizando técnicas de optimización.

### Implementación

**Dockerfile Optimizado:**
```dockerfile
# Stage 1: Build with Maven
FROM maven:3.9.0-openjdk-17-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run with Java (optimized)
FROM openjdk:17-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]

Técnicas Aplicadas

Imágenes base ligeras (Alpine)

maven:3.9.0-openjdk-17-alpine para construcción
openjdk:17-alpine para ejecución
Reducción significativa del tamaño final


Eliminación de archivos innecesarios

Solo se copia el .jar compilado a la imagen final
Las dependencias de Maven quedan en la etapa de build


Reducción de capas

Estructura optimizada del Dockerfile
Mínimo de instrucciones necesarias

Comandos
# Construir imagen optimizada
docker build -t vidalluyo0/api_be:optimized .

# Verificar tamaño
docker images vidalluyo0/api_be:optimized


🏗️ Actividad 2: Multi-Stage Builds
Objetivo
Separar el proceso de construcción del de ejecución para reducir el tamaño de la imagen final.
Implementación
El Dockerfile usa dos etapas:

Stage 1 (Builder): Compila el proyecto con Maven
Stage 2 (Runtime): Ejecuta solo el .jar en una imagen ligera

Comparación de Tamaños
Versión Pesada (sin Alpine):

FROM maven:3.8.4-openjdk-17 AS builder
# ... compilación ...

FROM openjdk:17
# ... ejecución ...


# Construir versión pesada
docker build -t vidalluyo0/api_be:big .

Resultados esperados:

Imagen con Alpine: ~180-200 MB
Imagen sin Alpine: ~450-500 MB