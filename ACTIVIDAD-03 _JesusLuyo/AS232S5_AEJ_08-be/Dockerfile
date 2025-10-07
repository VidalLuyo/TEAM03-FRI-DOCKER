FROM maven:3.8.4-openjdk-17 AS builder
WORKDIR /app

# Copiar archivos de Maven y el código fuente
COPY pom.xml .
COPY src ./src

# Ejecutar la construcción
RUN mvn clean package -DskipTests
# Usar la imagen base de OpenJDK para la ejecución
FROM openjdk:17
WORKDIR /app

# Copiar el archivo .jar generado desde la etapa de construcción
COPY --from=builder /app/target/*.jar app.jar
# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
