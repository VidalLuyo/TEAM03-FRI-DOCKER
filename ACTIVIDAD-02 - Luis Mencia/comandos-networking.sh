#!/bin/bash

echo "======================================"
echo "DEMO: Docker Networking - Capítulo 2"
echo "======================================"
echo ""

# Limpiar contenedores y redes anteriores
echo "1. Limpiando contenedores y redes anteriores..."
docker rm -f $(docker ps -aq) 2>/dev/null
docker network prune -f

echo ""
echo "2. ACTIVIDAD: Exposición de servicios en Docker"
echo "----------------------------------------------"

# Crear un servidor web Nginx exponiendo puertos
echo "▶ Creando servidor Nginx en puerto 8080..."
docker run -d -p 8080:80 --name servidor-web nginx

echo "▶ Creando servidor Apache en puerto 8081..."
docker run -d -p 8081:80 --name servidor-apache httpd

echo "✓ Servidores creados. Accede a:"
echo "  - Nginx: http://localhost:8080"
echo "  - Apache: http://localhost:8081"
echo ""

# Mostrar contenedores corriendo
echo "▶ Contenedores en ejecución:"
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"

echo ""
read -p "Presiona ENTER para continuar con redes personalizadas..."

echo ""
echo "3. ACTIVIDAD: Crear redes en Docker"
echo "----------------------------------------------"

# Crear redes personalizadas
echo "▶ Creando red 'frontend-network'..."
docker network create frontend-network

echo "▶ Creando red 'backend-network'..."
docker network create backend-network

echo ""
echo "▶ Redes disponibles:"
docker network ls

echo ""
read -p "Presiona ENTER para continuar con conexión de contenedores..."

echo ""
echo "4. ACTIVIDAD: Conectar contenedores en la misma red"
echo "----------------------------------------------"

# Crear aplicación multi-contenedor
echo "▶ Creando base de datos MySQL en red backend..."
docker run -d \
  --name mi-base-datos \
  --network backend-network \
  -e MYSQL_ROOT_PASSWORD=secret123 \
  -e MYSQL_DATABASE=mi_app \
  mysql:8

echo "▶ Creando aplicación web conectada a la BD..."
docker run -d \
  --name aplicacion-web \
  --network backend-network \
  -p 9090:80 \
  nginx

echo ""
echo "▶ Probando conectividad entre contenedores..."
echo "Haciendo ping desde 'aplicacion-web' hacia 'mi-base-datos':"
docker exec aplicacion-web apt-get update -qq 2>/dev/null
docker exec aplicacion-web apt-get install -y iputils-ping -qq 2>/dev/null
docker exec aplicacion-web ping -c 3 mi-base-datos

echo ""
echo "5. ACTIVIDAD: Inspeccionar redes y mapeo de puertos"
echo "----------------------------------------------"

echo "▶ Información de la red 'backend-network':"
docker network inspect backend-network --format '{{json .Containers}}' | python3 -m json.tool 2>/dev/null || docker network inspect backend-network

echo ""
echo "▶ Puertos mapeados del contenedor 'aplicacion-web':"
docker port aplicacion-web

echo ""
echo "======================================"
echo "✓ DEMO COMPLETADA"
echo "======================================"
echo ""
echo "📌 Resumen de servicios activos:"
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"

echo ""
echo "🌐 Accede a los servicios:"
echo "  - http://localhost:8080 (Nginx)"
echo "  - http://localhost:8081 (Apache)"
echo "  - http://localhost:9090 (Aplicación Web)"
echo ""
echo "🧹 Para limpiar todo ejecuta:"
echo "  docker rm -f \$(docker ps -aq)"
echo "  docker network prune -f"