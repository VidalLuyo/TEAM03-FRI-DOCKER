Write-Host "======================================" -ForegroundColor Cyan
Write-Host "DEMO: Docker Networking - Capitulo 2" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Limpiar contenedores y redes anteriores
Write-Host "1. Limpiando contenedores y redes anteriores..." -ForegroundColor Yellow
docker ps -aq | ForEach-Object { docker rm -f $_ } 2>$null
docker network prune -f

Write-Host ""
Write-Host "2. ACTIVIDAD: Exposicion de servicios en Docker" -ForegroundColor Green
Write-Host "----------------------------------------------"

# Crear servidores web
Write-Host "Creando servidor Nginx en puerto 8080..."
docker run -d -p 8080:80 --name servidor-web nginx

Write-Host "Creando servidor Apache en puerto 8081..."
docker run -d -p 8081:80 --name servidor-apache httpd

Write-Host "Servidores creados. Accede a:" -ForegroundColor Green
Write-Host "  - Nginx: http://localhost:8080"
Write-Host "  - Apache: http://localhost:8081"
Write-Host ""

Write-Host "Contenedores en ejecucion:"
docker ps --format "table {{.Names}}`t{{.Ports}}`t{{.Status}}"

Write-Host ""
Read-Host "Presiona ENTER para continuar con redes personalizadas"

Write-Host ""
Write-Host "3. ACTIVIDAD: Crear redes en Docker" -ForegroundColor Green
Write-Host "----------------------------------------------"

Write-Host "Creando red 'frontend-network'..."
docker network create frontend-network

Write-Host "Creando red 'backend-network'..."
docker network create backend-network

Write-Host ""
Write-Host "Redes disponibles:"
docker network ls

Write-Host ""
Read-Host "Presiona ENTER para continuar con conexion de contenedores"

Write-Host ""
Write-Host "4. ACTIVIDAD: Conectar contenedores en la misma red" -ForegroundColor Green
Write-Host "----------------------------------------------"

Write-Host "Creando base de datos MySQL en red backend..."
docker run -d --name mi-base-datos --network backend-network -e MYSQL_ROOT_PASSWORD=secret123 -e MYSQL_DATABASE=mi_app mysql:8

Write-Host "Creando aplicacion web conectada a la BD..."
docker run -d --name aplicacion-web --network backend-network -p 9090:80 nginx

Write-Host ""
Write-Host "Probando conectividad entre contenedores..."
Write-Host "Instalando ping en el contenedor..."
docker exec aplicacion-web apt-get update -qq 2>$null
docker exec aplicacion-web apt-get install -y iputils-ping -qq 2>$null
Write-Host "Haciendo ping desde 'aplicacion-web' hacia 'mi-base-datos':"
docker exec aplicacion-web ping -c 3 mi-base-datos

Write-Host ""
Write-Host "5. ACTIVIDAD: Inspeccionar redes y mapeo de puertos" -ForegroundColor Green
Write-Host "----------------------------------------------"

Write-Host "Informacion de la red 'backend-network':"
docker network inspect backend-network

Write-Host ""
Write-Host "Puertos mapeados del contenedor 'aplicacion-web':"
docker port aplicacion-web

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "DEMO COMPLETADA" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Resumen de servicios activos:"
docker ps --format "table {{.Names}}`t{{.Ports}}`t{{.Status}}"

Write-Host ""
Write-Host "Accede a los servicios:" -ForegroundColor Yellow
Write-Host "  - http://localhost:8080 (Nginx)"
Write-Host "  - http://localhost:8081 (Apache)"
Write-Host "  - http://localhost:9090 (Aplicacion Web)"
Write-Host ""
Write-Host "Para limpiar todo ejecuta:" -ForegroundColor Yellow
Write-Host "  docker ps -aq | ForEach-Object { docker rm -f `$_ }"
Write-Host "  docker network prune -f"
