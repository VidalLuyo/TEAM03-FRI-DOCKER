🐳 Capítulo 4: Docker Compose

🎯 Objetivo
Crear y gestionar aplicaciones multi-contenedor usando Docker Compose, definiendo dependencias, redes, volúmenes y mapeo de puertos.

🏗️ Arquitectura Implementada
HOST SYSTEM (Windows)
├── Puerto 8080 → Nginx Container (puerto 80)
└── Redis Container (puerto 6379)

RED DOCKER:
├── mi_red (bridge)
└── Comunicación: web ↔ redis

📊 Actividades Replicadas

🎯 Actividad 1: Crear archivo docker-compose.yml

Archivo `docker-compose.yml`:

```yaml
services:
  web:
    image: nginx:latest
    container_name: web
    ports:
      - "8080:80"
    volumes:
      - ./web:/usr/share/nginx/html:ro
    depends_on:
      - redis
    networks:
      - mi_red

  redis:
    image: redis:latest
    container_name: redis
    ports:
      - "6379:6379"
    networks:
      - mi_red

networks:
  mi_red:
    driver: bridge
```

Funcionamiento:

* Define los servicios `web` y `redis`.
* `depends_on` asegura que Redis se levante antes que web.
* Volúmenes permiten que cambios en `web/index.html` se reflejen automáticamente.

🎯 Actividad 2: Levantar los contenedores con Docker Compose

```powershell
# Navegar a la carpeta del proyecto
cd "C:\Actividad_04_GraciaGarcia\mi_app"

# Levantar contenedores en segundo plano
docker compose up -d
```

Comprobación:

```powershell
docker compose ps
```

* Muestra contenedores activos y puertos mapeados.

🎯 Actividad 3: Ver logs de los contenedores

```powershell
docker compose logs -f
```

* Permite ver la salida en tiempo real de Nginx y Redis.

🎯 Actividad 4: Acceder a la aplicación

1. Abrir navegador en: `http://localhost:8080`
2. Editar `web/index.html` en host → refrescar navegador → cambios reflejados automáticamente.

🎯 Actividad 5 (Opcional): Probar comunicación interna

```powershell
docker run -it --network mi_red busybox sh
# Dentro del contenedor:
ping redis
exit
```

* Confirma que los contenedores en la red `mi_red` pueden comunicarse por nombre de servicio.

🐳 Imágenes Docker Utilizadas

| Imagen | Versión | Propósito                | Puerto Interno |
| ------ | ------- | ------------------------ | -------------- |
| nginx  | latest  | Servidor web             | 80             |
| redis  | latest  | Base de datos en memoria | 6379           |

🔧 Comandos de Inspección Utilizados

```powershell
# Ver contenedores activos
docker compose ps

# Ver logs en tiempo real
docker compose logs -f

# Reiniciar un servicio específico
docker compose restart web

# Detener y eliminar contenedores, redes y volúmenes
docker compose down -v
```

🌐 Servicios Implementados

| Servicio    | URL/Acceso                                     | Estado   | Función                  |
| ----------- | ---------------------------------------------- | -------- | ------------------------ |
| Nginx (web) | [http://localhost:8080](http://localhost:8080) | ✅ Activo | Servir HTML              |
| Redis       | Interno (6379)                                 | ✅ Activo | Base de datos en memoria |

🧹 Limpieza

```powershell
docker compose down -v
```

* Detiene contenedores y elimina volúmenes y red creada.

✅ Conceptos Demostrados

* ✅ Multi-container setup: Levantaste web + Redis juntos.
* ✅ Depends_on: Gestionaste dependencias de inicio.
* ✅ Volúmenes: Cambios reflejados en tiempo real.
* ✅ Port Mapping: Acceso al host por `localhost:8080`.
