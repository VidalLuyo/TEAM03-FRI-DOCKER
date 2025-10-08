FROM nginx:latest

# Exponer puertos que la aplicación usará
EXPOSE 80
EXPOSE 443

# Copiar página HTML personalizada
COPY index.html /usr/share/nginx/html/

# Etiquetas de metadata
LABEL maintainer="Luis Mencia"
LABEL description="Servidor Nginx con puertos expuestos - Capitulo 2 DataCamp"