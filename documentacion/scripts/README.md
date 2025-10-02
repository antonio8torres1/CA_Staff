# Scripts de Certificados

Scripts para automatizar la creación de certificados con OpenSSL.

## ca.sh

Script para generar certificados de servidor firmados por tu CA.

### Uso

**Generar un certificado individual:**
```bash
./ca.sh ejemplo.com
```

**Generar certificados desde un archivo:**
```bash
./ca.sh -f dominios.txt
```

### Formato del archivo de dominios

Crea un archivo de texto con un dominio por línea:
```
ejemplo1.com
ejemplo2.com
ejemplo3.com
```

Las líneas vacías y comentarios (que empiezan con `#`) son ignorados.

### Archivos generados

Para cada dominio se crean:
- `private/dominio-key.pem` - Clave privada del servidor
- `csrs/dominio.csr` - Solicitud de firma de certificado
- `certs/dominio-cert.pem` - Certificado firmado

## server.sh

Script básico para generar un certificado de servidor.

### Uso

```bash
./server.sh ejemplo.com
```

### Archivos generados

- `private/dominio-key.pem` - Clave privada
- `dominio.csr` - Solicitud de firma
- `certs/dominio-cert.pem` - Certificado firmado

## openssl.cnf

Archivo de configuración de OpenSSL para la CA.

### Personalización

Modifica la sección `[ req_distinguished_name ]` con tus datos:
```
countryName                     = SV
stateOrProvinceName             = El Salvador
localityName                    = San Salvador
organizationName                = UES
organizationalUnitName          = TPI115
commonName                      = tu-dominio.com
emailAddress                    = tu@email.com
```

Modifica la sección `[ alt_names ]` para los dominios que certificarás:
```
DNS.1 = www.ejemplo.com
DNS.2 = ejemplo.com
DNS.3 = *.ejemplo.com
IP.1 = 192.168.1.10
```
