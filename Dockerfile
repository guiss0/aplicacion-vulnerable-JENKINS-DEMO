# Usar la imagen oficial de Nginx
FROM nginx:latest

# Copiar los archivos de configuración personalizados (si los tienes)
# COPY ./mi_configuracion_nginx.conf /etc/nginx/nginx.conf

# Exponer el puerto 80 para el tráfico web
EXPOSE 80

# Ejecutar Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
