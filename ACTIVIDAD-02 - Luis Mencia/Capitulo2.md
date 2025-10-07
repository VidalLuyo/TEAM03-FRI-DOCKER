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

## ✅ Conceptos Demostrados

- ✅ **Port Mapping**: Exposición de servicios al host
- ✅ **Custom Networks**: Redes personalizadas para aislamiento
- ✅ **Container Communication**: Comunicación por nombre DNS
- ✅ **Network Inspection**: Inspección de configuración de red
- ✅ **Multi-container Setup**: Aplicación con múltiples servicios

---

**🎯 Replicación exitosa del Capítulo 2: Networking de DataCamp Intermediate Docker**