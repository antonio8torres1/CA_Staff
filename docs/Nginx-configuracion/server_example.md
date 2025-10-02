# Configuración Básica de Nginx

## Archivo de Configuración

```nginx
# /etc/nginx/sites-available/tudominio.com

# Bloque HTTP - Redirige todo el tráfico a HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name tudominio.com www.tudominio.com;

    # Redirección permanente a HTTPS
    return 301 https://$server_name$request_uri;
}

# Bloque HTTPS - Configuración principal
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name tudominio.com www.tudominio.com;

    # Certificados SSL
    ssl_certificate /etc/nginx/ssl/tudominio.com.crt;
    ssl_certificate_key /etc/nginx/ssl/tudominio.com.key;

    # Protocolos y cifrados SSL
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    # Directorio raíz del sitio
    root /var/www/tudominio.com;
    index index.html index.htm;

    # Logs
    access_log /var/log/nginx/tudominio_access.log;
    error_log /var/log/nginx/tudominio_error.log;

    # Ubicación principal
    location / {
        try_files $uri $uri/ =404;
    }

    # Seguridad - Ocultar versión de Nginx
    server_tokens off;

    # Headers de seguridad
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
```

---

## Desglose de la Configuración

### Bloque HTTP (Puerto 80)

**`listen 80` y `listen [::]:80`**

- Escucha conexiones HTTP en IPv4 e IPv6 en el puerto 80 (puerto estándar HTTP)

**`server_name tudominio.com www.tudominio.com`**

- Define los nombres de dominio que este bloque manejará

**`return 301 https://$server_name$request_uri`**

- Redirección permanente (301) de HTTP a HTTPS
- Preserva la URL completa incluyendo parámetros

### Bloque HTTPS (Puerto 443)

**`listen 443 ssl http2`**

- Escucha en puerto 443 con SSL/TLS habilitado
- `http2` activa el protocolo HTTP/2 para mejor rendimiento

**Certificados SSL**

- `ssl_certificate`: Ruta al certificado público
- `ssl_certificate_key`: Ruta a la clave privada

**Configuración SSL**

- `ssl_protocols`: Versiones de TLS permitidas (solo las seguras)
- `ssl_ciphers`: Algoritmos de cifrado permitidos
- `ssl_prefer_server_ciphers`: El servidor decide el cifrado a usar

**`root /var/www/tudominio.com`**

- Directorio donde están los archivos del sitio web

**`index index.html index.htm`**

- Archivos que se buscan como página de inicio

**Logs**

- `access_log`: Registra todas las peticiones al servidor
- `error_log`: Registra errores y problemas

**`location /`**

- `try_files`: Intenta servir el archivo solicitado, luego directorio, luego error 404

**Headers de Seguridad**

- `X-Frame-Options`: Previene clickjacking
- `X-Content-Type-Options`: Previene MIME type sniffing
- `X-XSS-Protection`: Protección contra XSS en navegadores antiguos

**`server_tokens off`**

- Oculta la versión de Nginx en las respuestas

---

## Pasos para Activar

1. Crear el archivo de configuración:

   ```bash
   sudo nano /etc/nginx/sites-available/tudominio.com
   ```

2. Crear enlace simbólico:

   ```bash
   sudo ln -s /etc/nginx/sites-available/tudominio.com /etc/nginx/sites-enabled/
   ```

3. Verificar la configuración:

   ```bash
   sudo nginx -t
   ```

4. Recargar Nginx:
   ```bash
   sudo systemctl reload nginx
   ```

---
