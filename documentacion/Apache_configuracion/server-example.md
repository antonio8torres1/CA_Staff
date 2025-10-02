## Archivo de Configuración

```apache
# /etc/apache2/sites-available/tudominio.com.conf

# Bloque HTTP - Redirige todo el tráfico a HTTPS
<VirtualHost *:80>
    ServerName tudominio.com
    ServerAlias www.tudominio.com

    # Redirección permanente a HTTPS
    Redirect permanent / https://tudominio.com/

    # Logs
    ErrorLog ${APACHE_LOG_DIR}/tudominio_error.log
    CustomLog ${APACHE_LOG_DIR}/tudominio_access.log combined
</VirtualHost>

# Bloque HTTPS - Configuración principal
<VirtualHost *:443>
    ServerName tudominio.com
    ServerAlias www.tudominio.com

    # Directorio raíz del sitio
    DocumentRoot /var/www/tudominio.com

    # Configuración del directorio
    <Directory /var/www/tudominio.com>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # Habilitar SSL
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/tudominio.com.crt
    SSLCertificateKeyFile /etc/ssl/private/tudominio.com.key

    # Protocolos y cifrados SSL
    SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
    SSLCipherSuite HIGH:!aNULL:!MD5
    SSLHonorCipherOrder on

    # Headers de seguridad
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-XSS-Protection "1; mode=block"
    Header always set Strict-Transport-Security "max-age=31536000"

    # Ocultar versión de Apache
    ServerSignature Off

    # Logs
    ErrorLog ${APACHE_LOG_DIR}/tudominio_ssl_error.log
    CustomLog ${APACHE_LOG_DIR}/tudominio_ssl_access.log combined
</VirtualHost>

# Configuración SSL moderna (opcional pero recomendada)
SSLCompression off
SSLSessionTickets off
```

---

## Desglose de la Configuración

### Bloque HTTP (Puerto 80)

**`<VirtualHost *:80>`**

- Define un host virtual que escucha en el puerto 80 (HTTP) en todas las interfaces

**`ServerName` y `ServerAlias`**

- `ServerName`: Dominio principal del sitio
- `ServerAlias`: Dominios alternativos (como www)

**`Redirect permanent / https://tudominio.com/`**

- Redirección permanente (301) de todas las URLs a HTTPS
- Mantiene la ruta completa de la URL

**Logs**

- `ErrorLog`: Registra errores del servidor
- `CustomLog combined`: Registra accesos con formato detallado

### Bloque HTTPS (Puerto 443)

**`<VirtualHost *:443>`**

- Host virtual para conexiones HTTPS seguras

**`DocumentRoot /var/www/tudominio.com`**

- Directorio raíz donde están los archivos del sitio web

**Configuración del Directorio**

- `Options -Indexes`: Deshabilita listado de directorios (seguridad)
- `+FollowSymLinks`: Permite seguir enlaces simbólicos
- `AllowOverride All`: Permite usar archivos .htaccess
- `Require all granted`: Permite acceso a todos los visitantes

**Configuración SSL**

- `SSLEngine on`: Activa el módulo SSL
- `SSLCertificateFile`: Ruta al certificado público
- `SSLCertificateKeyFile`: Ruta a la clave privada

**Protocolos SSL/TLS**

- `SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1`: Usa todos los protocolos EXCEPTO los inseguros
- Solo permite TLSv1.2 y TLSv1.3 (los seguros)

**Cifrados**

- `SSLCipherSuite HIGH`: Solo cifrados fuertes
- `SSLHonorCipherOrder on`: El servidor elige el cifrado (más seguro)

**Headers de Seguridad**

- `X-Frame-Options`: Previene clickjacking
- `X-Content-Type-Options`: Previene MIME sniffing
- `X-XSS-Protection`: Protección contra ataques XSS
- `Strict-Transport-Security`: Fuerza HTTPS por 1 año (HSTS)

**`ServerSignature Off`**

- Oculta información de versión de Apache en páginas de error

**Configuraciones SSL Adicionales**

- `SSLCompression off`: Deshabilita compresión SSL (previene CRIME attack)
- `SSLSessionTickets off`: Mayor privacidad en sesiones SSL

---

## Módulos Necesarios

Habilita los módulos requeridos:

```bash
sudo a2enmod ssl
sudo a2enmod headers
sudo a2enmod rewrite
```

---

## Pasos para Activar

1. Crear el archivo de configuración:

   ```bash
   sudo nano /etc/apache2/sites-available/tudominio.com.conf
   ```

2. Habilitar el sitio:

   ```bash
   sudo a2ensite tudominio.com.conf
   ```

3. Verificar la configuración:

   ```bash
   sudo apache2ctl configtest
   ```

4. Recargar Apache:
   ```bash
   sudo systemctl reload apache2
   ```

---

## Configuración Global de Seguridad

Edita `/etc/apache2/conf-available/security.conf`:

```apache
ServerTokens Prod
ServerSignature Off
TraceEnable Off
```

Habilita la configuración:

```bash
sudo a2enconf security
sudo systemctl reload apache2
```

---

## Archivo .htaccess Opcional

Si necesitas configuraciones adicionales, crea `/var/www/tudominio.com/.htaccess`:

```apache
# Forzar HTTPS (alternativa)
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Protección adicional
<FilesMatch "\.(htaccess|htpasswd|ini|log|sh|sql)$">
    Require all denied
</FilesMatch>
```
