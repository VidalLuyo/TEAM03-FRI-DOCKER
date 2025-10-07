# Optimización de Imágenes Docker

🎯 **Objetivo**: Crear imágenes más pequeñas y eficientes.

🏗️ **Arquitectura Implementada**  
- **Sistema Host**: Windows  
- **Imagen Usada**: `openjdk:17-alpine` (para ejecución) y `maven:3.9.0-openjdk-17-alpine` (para construcción).

🛠️ **Dockerfile - Versión optimizada (Usando Alpine)**

```Dockerfile
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


🎯 Actividad 1: Optimizar imágenes de Docker

Uso de imágenes base ligeras (Alpine): Se utilizó openjdk:17-alpine y maven:3.9.0-openjdk-17-alpine para reducir el tamaño de la imagen.

Eliminación de archivos innecesarios: Al usar multi-stage builds, solo se incluye el archivo .jar necesario, eliminando las dependencias de Maven.

Reducción de capas: El Dockerfile fue estructurado de manera que se optimiza el número de capas, evitando que se copien archivos innecesarios y limitando la cantidad de instrucciones COPY y RUN.


🛠️ Dockerfile - Versión más pesada (Sin Alpine)

# Stage 1: Build with Maven
FROM maven:3.8.4-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run with Java (heavy version)
FROM openjdk:17
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
