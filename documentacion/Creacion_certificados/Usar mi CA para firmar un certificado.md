
## 1. Crear la clave privada para el servidor
```bash
openssl genrsa -out private/servidor-key.pem 2048
```

Se necesitara un archivo personalizado .cnf para el dominio a certificar
## 2. Crear la solicitud de firma(CSR)
```bash
openssl req -config openssl.cnf -key private/servidor-key.pem -new -sha256 -out servidor.csr
```

### `openssl`

Herramienta de línea de comandos para operaciones criptográficas y gestión de certificados SSL/TLS.

### `req`

Subcomando para:

- Gestionar solicitudes de certificados (Certificate Signing Requests - CSR)
- Crear, procesar y verificar CSRs
- Generar certificados autofirmados (cuando se usa con -x509)

### `-config openssl.cnf`

Especifica el archivo de configuración:

- **Archivo**: `openssl.cnf`
- Contiene parámetros y extensiones predefinidas
- Define campos obligatorios y opcionales
- Puede incluir configuraciones para Subject Alternative Names (SANs)
- Evita tener que introducir manualmente todos los parámetros

### `-key private/servidor-key.pem`

Clave privada a utilizar:

- **Archivo**: `private/servidor-key.pem`
- Clave privada RSA del servidor (debe existir previamente)
- Se usa para firmar la solicitud CSR
- **Nota**: "servidor" indica que es para un servidor específico, no para CA

### `-new`

Indica crear una nueva solicitud:

- Genera un nuevo CSR desde cero
- Solicitará información del sujeto del certificado
- Crea una solicitud que será enviada a una CA para firmar

### `-sha256`

Algoritmo de hash para la firma:

- **SHA-256**: Secure Hash Algorithm de 256 bits
- Más seguro que SHA-1 (obsoleto)
- Estándar actual recomendado por las CAs
- Genera la huella digital de la solicitud

### `-out servidor.csr`

Archivo de salida del CSR:

- **Nombre**: `servidor.csr`
- **Formato**: PEM (texto codificado en base64)
- **Extensión**: `.csr` (Certificate Signing Request)
- Este archivo se envía a la CA para obtener el certificado firmado

## ¿Qué es un CSR?

Un **Certificate Signing Request (CSR)** es:

- Una solicitud formal para obtener un certificado digital
- Contiene la clave pública y información de identidad
- **NO contiene la clave privada** (se mantiene secreta)
- Se envía a una Autoridad Certificadora (CA) para su firma

## Información típica solicitada

Al ejecutar este comando, se pedirán datos como:

| Campo                        | Descripción               | Ejemplo               |
| ---------------------------- | ------------------------- | --------------------- |
| **Country Name (C)**         | Código de país ISO        | `ES`                  |
| **State/Province (ST)**      | Estado o provincia        | `Madrid`              |
| **City/Locality (L)**        | Ciudad                    | `Madrid`              |
| **Organization (O)**         | Nombre de la organización | `Mi Empresa S.L.`     |
| **Organizational Unit (OU)** | Departamento              | `IT Department`       |
| **Common Name (CN)**         | Nombre del servidor       | `www.midominio.com`   |
| **Email Address**            | Correo de contacto        | `admin@midominio.com` |

Aquí especificas el **Common Name (CN)** que debe coincidir con el **dominio o IP**  
(ejemplo: `miweb.local` o `192.168.1.10`).

## 3. Firmar el certificado con tu CA
```bash
openssl ca -config openssl.cnf -extensions server_cert -days 365 -notext -md sha256 -in servidor.csr -out certs/servidor-cert.pem
```

### `openssl`

Herramienta de línea de comandos para operaciones criptográficas y gestión de certificados SSL/TLS.

### `ca`

Subcomando para operaciones de Autoridad Certificadora:

- Firma Certificate Signing Requests (CSRs)
- Gestiona base de datos de certificados emitidos
- Revoca certificados cuando es necesario
- Mantiene el registro de certificados válidos y revocados

### `-config openssl.cnf`

Archivo de configuración de la CA:

- **Archivo**: `openssl.cnf`
- Define la configuración de la Autoridad Certificadora
- Especifica ubicación de archivos (clave privada, certificado CA, base de datos)
- Contiene políticas de emisión de certificados
- Define extensiones y restricciones

### `-extensions server_cert`

Sección de extensiones a aplicar:

- **Sección**: `server_cert` (definida en openssl.cnf)
- Especifica el uso previsto del certificado
- Típicamente incluye extensiones como:
    - `keyUsage = keyEncipherment, dataEncipherment`
    - `extendedKeyUsage = serverAuth`
    - `subjectAltName` (nombres alternativos)

### `-days 365`

Período de validez del certificado:

- **365 días** = **1 año** de validez
- Tiempo desde la fecha de emisión hasta expiración
- Más corto que el certificado CA (que suele ser 10 años)
- Período típico para certificados de servidor

### `-notext`

Control de formato de salida:

- **NO incluye** la representación en texto del certificado
- Solo genera el certificado en formato PEM
- Hace el archivo de salida más limpio y pequeño
- Sin este parámetro, incluiría detalles legibles del certificado

### `-md sha256`

Algoritmo de hash para la firma:

- **SHA-256**: Secure Hash Algorithm de 256 bits
- Algoritmo usado por la CA para firmar el certificado
- Más seguro que SHA-1 (obsoleto)
- Debe coincidir con las políticas de la CA

### `-in servidor.csr`

Archivo CSR de entrada:

- **Archivo**: `servidor.csr` (generado previamente)
- Certificate Signing Request que será firmado
- Contiene la clave pública e información del servidor
- Debe haber sido creado con la clave privada correspondiente

### `-out certs/servidor-cert.pem`

Archivo de salida del certificado firmado:

- **Directorio**: `certs/` (organización de archivos)
- **Nombre**: `servidor-cert.pem`
- **Formato**: PEM (certificado X.509 firmado)
- Este es el certificado final para instalar en el servidor
## 📌 5. Instalar la CA en los clientes

Para que los navegadores/PCs confíen en tus certificados, debes instalar **ca.cert.pem** como una **Autoridad de Certificación confiable** en cada máquina.

- **Linux** → copia en `/usr/local/share/ca-certificates/` y corre `update-ca-certificates`.
    
- **Windows** → importar desde “Administrar certificados” → “Entidades de certificación raíz de confianza”.
    
- **Firefox** → Configuración → Certificados → Autoridades → Importar.

## 6. Confirmar certificado
```bash
# Ver detalles del certificado
openssl x509 -in certs/servidor-cert.pem -text -noout

# Verificar que fue firmado por la CA
openssl verify -CAfile ca-cert.pem certs/servidor-cert.pem

# Verificar fechas de validez
openssl x509 -in certs/servidor-cert.pem -dates -noout

# Ver el subject del certificado
openssl x509 -in certs/servidor-cert.pem -subject -noout
```


## Convertir a pkcs12

```bash
openssl pkcs12 -export -out certificado.p12 -inkey clave-privada.pem -in certificado.pem
```

```bash
openssl pkcs12 -info -in certificado.p12
```