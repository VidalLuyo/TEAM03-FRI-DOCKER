# 🐳 Capítulo 2: Docker Networking

## 🎯 Objetivo
Replicar las actividades de **Exposición de Servicios** y **Networking** del Capítulo 2 de DataCamp Intermediate Docker.

## 🏗️ Arquitectura Implementada

```
HOST SYSTEM (Windows)
├── Puerto 8080 → Nginx Container (puerto 80)
├── Puerto 8081 → Apache Container (puerto 80)  
└── Puerto 9090 → Web App Container (puerto 80)

REDES DOCKER:
├── frontend-network (bridge)
├── backend-network (bridge)
└── Comunicación: Web App ↔ MySQL Database
```

## 📊 Actividades Replicadas

### 🎯 Actividad 1: Exposición de Servicios (Port Mapping)

**Comandos ejecutados:**
```bash
# Servidor Nginx en puerto 8080
docker run -d -p 8080:80 --name servidor-web nginx

# Servidor Apache en puerto 8081
docker run -d -p 8081:80 --name servidor-apache httpd
```

**Funcionamiento:**
- `-d`: Ejecuta en segundo plano
- `-p 8080:80`: Mapea puerto 8080 del host → puerto 80 del contenedor
- `--name`: Asigna nombre específico al contenedor

**Resultado:** Servicios web accesibles desde el navegador

### 🎯 Actividad 2: Redes Personalizadas

**Comandos ejecutados:**
```bash
# Crear redes aisladas
docker network create frontend-network
docker network create backend-network

# Listar redes disponibles
docker network ls
```

**Funcionamiento:**
- Crea redes bridge personalizadas
- Permite aislamiento entre grupos de contenedores
- Habilita comunicación por nombre de contenedor

### 🎯 Actividad 3: Conectividad entre Contenedores

**Comandos ejecutados:**
```bash
# Base de datos MySQL en red backend
docker run -d \
  --name mi-base-datos \
  --network backend-network \
  -e MYSQL_ROOT_PASSWORD=secret123 \
  -e MYSQL_DATABASE=mi_app \
  mysql:8

# Aplicación web conectada a BD
docker run -d \
  --name aplicacion-web \
  --network backend-network \
  -p 9090:80 \
  nginx
```

**Funcionamiento:**
- `--network`: Conecta contenedor a red específica
- `-e`: Define variables de entorno
- Contenedores se comunican usando nombres como hostnames

### 🎯 Actividad 4: Pruebas de Conectividad

**Comandos ejecutados:**
```bash
# Instalar herramientas de red
docker exec aplicacion-web apt-get update -qq
docker exec aplicacion-web apt-get install -y iputils-ping -qq

# Probar conectividad
docker exec aplicacion-web ping -c 3 mi-base-datos
```

**Resultado obtenido:**
```
PING mi-base-datos (172.19.0.2) 56(84) bytes of data.
64 bytes from mi-base-datos.backend-network (172.19.0.2): icmp_seq=1 ttl=64 time=0.304 ms
64 bytes from mi-base-datos.backend-network (172.19.0.2): icmp_seq=2 ttl=64 time=0.126 ms
64 bytes from mi-base-datos.backend-network (172.19.0.2): icmp_seq=3 ttl=64 time=0.198 ms
```

## 🐳 Imágenes Docker Utilizadas

| Imagen | Versión | Propósito | Puerto Interno |
|--------|---------|-----------|----------------|
| `nginx` | latest | Servidor web principal | 80 |
| `httpd` | latest | Servidor Apache | 80 |
| `mysql` | 8 | Base de datos | 3306 |

## 🔧 Comandos de Inspección Utilizados

### Ver contenedores activos
```bash
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"
```

### Inspeccionar red backend
```bash
docker network inspect backend-network
```

### Ver puertos mapeados
```bash
docker port aplicacion-web
```

**Salida obtenida:**
```
80/tcp -> 0.0.0.0:9090
80/tcp -> [::]:9090
```

## 🌐 Servicios Implementados

| Servicio | URL | Estado | Función |
|----------|-----|--------|---------|
| Nginx | http://localhost:8080 | ✅ Activo | Servidor web |
| Apache | http://localhost:8081 | ✅ Activo | Servidor alternativo |
| Web App | http://localhost:9090 | ✅ Activo | App conectada a BD |
| MySQL | Interno (172.19.0.2) | ✅ Activo | Base de datos |

## 🚀 Ejecución del Proyecto

### Script automatizado (Windows):
```powershell
.\comandos-networking.ps1
```

### Script automatizado (Linux/WSL):
```bash
./comandos-networking.sh
```

## 🧹 Limpieza

```bash
# Eliminar todos los contenedores
docker rm -f $(docker ps -aq)

# Eliminar redes personalizadas
docker network prune -f
```

## 📚 Actividades Adicionales de DataCamp

### 🎯 Actividad 5: Mapeo de Puertos con Dockerfile

**Crear Dockerfile con EXPOSE:**
```dockerfile
FROM nginx:latest
EXPOSE 80
EXPOSE 443
COPY index.html /usr/share/nginx/html/
```

**Comandos:**
```bash
# Construir imagen con puertos expuestos
docker build -t mi-nginx-custom .

# Ejecutar con mapeo automático (-P)
docker run -d -P --name web-auto mi-nginx-custom

# Ver puerto asignado automáticamente
docker port web-auto
```

**Resultado:** Docker asigna puertos aleatorios del host a los puertos expuestos

### 🎯 Actividad 6: Mapeo Efímero (Ephemeral Mapping)

**Comandos ejecutados:**
```bash
# Usar -P para mapeo automático de puertos
docker run -d -P --name nginx-ephemeral nginx

# Ver qué puerto asignó Docker
docker port nginx-ephemeral
```

**Salida esperada:**
```
80/tcp -> 0.0.0.0:32768
```

**Funcionamiento:** Docker asigna puertos aleatorios del rango 32768-65535

### 🎯 Actividad 7: Múltiples Contenedores, Mismo Puerto Host

**Pregunta:** ¿Pueden dos contenedores usar el mismo puerto del host?

**Respuesta:** ❌ NO. Cada puerto del host solo puede ser usado por un contenedor.

**Demostración:**
```bash
# Primer contenedor en puerto 8080
docker run -d -p 8080:80 --name web1 nginx

# Intentar segundo contenedor en mismo puerto (FALLA)
docker run -d -p 8080:80 --name web2 nginx
# Error: port is already allocated
```

**Solución:** Usar puertos diferentes del host
```bash
docker run -d -p 8081:80 --name web2 nginx
```

### 🎯 Actividad 8: Rangos de IP en Redes Docker

**Comandos ejecutados:**
```bash
# Crear red con rango IP específico
docker network create --subnet=172.20.0.0/16 mi-red-custom

# Inspeccionar rango de IP
docker network inspect mi-red-custom --format '{{.IPAM.Config}}'

# Crear contenedor con IP específica
docker run -d --network mi-red-custom --ip 172.20.0.10 --name web-ip nginx
```

**Resultado obtenido:**
```
[{172.20.0.0/16  172.20.0.1 map[]}]
```

### 🎯 Actividad 9: Remover Contenedores de Redes

**Comandos ejecutados:**
```bash
# Desconectar contenedor de una red
docker network disconnect backend-network aplicacion-web

# Verificar que se desconectó
docker network inspect backend-network

# Reconectar a la red
docker network connect backend-network aplicacion-web
```

**Funcionamiento:** Permite gestionar dinámicamente las conexiones de red de contenedores en ejecución

### 🎯 Actividad 10: Verificar IP del Contenedor

**Comandos ejecutados:**
```bash
# Ver IP de un contenedor específico
docker inspect aplicacion-web --format '{{.NetworkSettings.IPAddress}}'

# Ver todas las IPs en todas las redes
docker inspect aplicacion-web --format '{{json .NetworkSettings.Networks}}'
```

**Salida obtenida:**
```json
{
  "backend-network": {
    "IPAddress": "172.19.0.3",
    "Gateway": "172.19.0.1"
  }
}
```

## 🔍 Validación de Puertos (Valid Ports)

### Puertos Válidos en Docker:
- ✅ **Rango válido:** 1-65535
- ✅ **Puertos privilegiados:** 1-1023 (requieren permisos root)
- ✅ **Puertos registrados:** 1024-49151
- ✅ **Puertos dinámicos:** 49152-65535

**Ejemplos:**
```bash
# Puerto válido
docker run -d -p 8080:80 nginx  ✅

# Puerto inválido (fuera de rango)
docker run -d -p 70000:80 nginx  ❌

# Puerto privilegiado (puede requerir permisos)
docker run -d -p 80:80 nginx  ⚠️
```

## ✅ Conceptos Demostrados

- ✅ **Port Mapping**: Exposición de servicios al host
- ✅ **Ephemeral Ports**: Mapeo automático de puertos
- ✅ **EXPOSE en Dockerfile**: Documentar puertos en imágenes
- ✅ **Custom Networks**: Redes personalizadas para aislamiento
- ✅ **IP Ranges**: Configuración de subredes personalizadas
- ✅ **Container Communication**: Comunicación por nombre DNS
- ✅ **Network Inspection**: Inspección de configuración de red
- ✅ **Dynamic Network Management**: Conectar/desconectar contenedores
- ✅ **Multi-container Setup**: Aplicación con múltiples servicios
- ✅ **Port Validation**: Comprensión de rangos de puertos válidos

---

**🎯 Replicación completa del Capítulo 2: Networking de DataCamp Intermediate Docker**