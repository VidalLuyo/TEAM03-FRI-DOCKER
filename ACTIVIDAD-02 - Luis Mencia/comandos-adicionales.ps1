Write-Host "======================================" -ForegroundColor Cyan
Write-Host "ACTIVIDADES ADICIONALES - Capitulo 2" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# ACTIVIDAD 5: Dockerfile con EXPOSE
Write-Host "ACTIVIDAD 5: Mapeo de Puertos con Dockerfile" -ForegroundColor Green
Write-Host "----------------------------------------------"

Write-Host "▶ Construyendo imagen personalizada con EXPOSE..."
docker build -t mi-nginx-custom .

Write-Host "▶ Ejecutando con mapeo automatico (-P)..."
docker run -d -P --name web-auto mi-nginx-custom

Write-Host "▶ Puerto asignado automaticamente:"
docker port web-auto

Write-Host ""
Read-Host "Presiona ENTER para continuar con mapeo efimero"

# ACTIVIDAD 6: Mapeo Efímero
Write-Host ""
Write-Host "ACTIVIDAD 6: Mapeo Efimero (Ephemeral Mapping)" -ForegroundColor Green
Write-Host "----------------------------------------------"

Write-Host "▶ Creando contenedor con puerto efimero..."
docker run -d -P --name nginx-ephemeral nginx

Write-Host "▶ Puerto efimero asignado:"
docker port nginx-ephemeral

Write-Host ""
Read-Host "Presiona ENTER para continuar con conflicto de puertos"

# ACTIVIDAD 7: Múltiples Contenedores, Mismo Puerto
Write-Host ""
Write-Host "ACTIVIDAD 7: Multiples Contenedores, Mismo Puerto Host" -ForegroundColor Green
Write-Host "----------------------------------------------"

Write-Host "▶ Creando primer contenedor en puerto 8085..."
docker run -d -p 8085:80 --name web-test1 nginx

Write-Host "▶ Intentando crear segundo contenedor en mismo puerto (esto fallara)..."
docker run -d -p 8085:80 --name web-test2 nginx 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Host "✓ Como esperado: El puerto ya esta en uso" -ForegroundColor Yellow
}

Write-Host "▶ Creando segundo contenedor en puerto diferente (8086)..."
docker run -d -p 8086:80 --name web-test2 nginx

Write-Host ""
Read-Host "Presiona ENTER para continuar con rangos de IP"

# ACTIVIDAD 8: Rangos de IP
Write-Host ""
Write-Host "ACTIVIDAD 8: Rangos de IP en Redes Docker" -ForegroundColor Green
Write-Host "----------------------------------------------"

Write-Host "▶ Creando red con rango IP especifico..."
docker network create --subnet=172.20.0.0/16 mi-red-custom

Write-Host "▶ Inspeccionando rango de IP:"
docker network inspect mi-red-custom --format '{{.IPAM.Config}}'

Write-Host "▶ Creando contenedor con IP especifica (172.20.0.10)..."
docker run -d --network mi-red-custom --ip 172.20.0.10 --name web-ip nginx

Write-Host "▶ Verificando IP asignada:"
docker inspect web-ip --format '{{.NetworkSettings.Networks.mi-red-custom.IPAddress}}'

Write-Host ""
Read-Host "Presiona ENTER para continuar con gestion de redes"

# ACTIVIDAD 9: Remover Contenedores de Redes
Write-Host ""
Write-Host "ACTIVIDAD 9: Remover Contenedores de Redes" -ForegroundColor Green
Write-Host "----------------------------------------------"

Write-Host "▶ Creando contenedor de prueba..."
docker run -d --name test-network nginx

Write-Host "▶ Conectando a mi-red-custom..."
docker network connect mi-red-custom test-network

Write-Host "▶ Verificando conexion:"
docker inspect test-network --format '{{json .NetworkSettings.Networks}}' | ConvertFrom-Json | ConvertTo-Json

Write-Host "▶ Desconectando de mi-red-custom..."
docker network disconnect mi-red-custom test-network

Write-Host "✓ Contenedor desconectado de la red"

Write-Host ""
Read-Host "Presiona ENTER para continuar con verificacion de IPs"

# ACTIVIDAD 10: Verificar IP del Contenedor
Write-Host ""
Write-Host "ACTIVIDAD 10: Verificar IP del Contenedor" -ForegroundColor Green
Write-Host "----------------------------------------------"

Write-Host "▶ IP del contenedor web-ip:"
docker inspect web-ip --format '{{.NetworkSettings.Networks.mi-red-custom.IPAddress}}'

Write-Host "▶ Todas las redes del contenedor test-network:"
docker inspect test-network --format '{{json .NetworkSettings.Networks}}'

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "✓ ACTIVIDADES ADICIONALES COMPLETADAS" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📌 Resumen de contenedores creados:"
docker ps --format "table {{.Names}}`t{{.Ports}}`t{{.Status}}"

Write-Host ""
Write-Host "🌐 Servicios adicionales disponibles:" -ForegroundColor Yellow
Write-Host "  - Web Auto: http://localhost:[puerto-efimero]"
Write-Host "  - Web Test 1: http://localhost:8085"
Write-Host "  - Web Test 2: http://localhost:8086"
Write-Host ""
Write-Host "🧹 Para limpiar todo ejecuta:" -ForegroundColor Yellow
Write-Host "  docker rm -f $(docker ps -aq)"
Write-Host "  docker network prune -f"
Write-Host "  docker rmi mi-nginx-custom"