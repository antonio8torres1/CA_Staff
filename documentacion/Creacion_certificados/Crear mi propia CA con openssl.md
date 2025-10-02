## 📌 1. Crear la estructura de la CA

Primero organiza un directorio para tu CA:
```bash
mkdir -p ~/miCA/{certs,crl,newcerts,private}
chmod 700 ~/miCA/private
touch ~/miCA/index.txt
echo 1000 > ~/miCA/serial
```

- **certs/** → aquí estarán los certificados firmados.    
- **private/** → almacena la clave privada de la CA.    
- **newcerts/** → donde OpenSSL guarda los nuevos certs emitidos.    
- **index.txt** → base de datos de certificados emitidos.    
- **serial** → número de serie inicial.

## 📌 2. Crear la clave privada de la CA

```bash
openssl genrsa -aes256 -out private/ca-key.pem 4096
```
### `openssl`

Herramienta de línea de comandos para trabajar con:

- Certificados SSL/TLS
- Operaciones criptográficas
- Gestión de claves públicas y privadas

### `genrsa`

Subcomando específico que:

- Genera una clave privada RSA
- RSA: algoritmo de cifrado asimétrico (Rivest-Shamir-Adleman)
- Crea el par de claves matemáticamente relacionadas

### `-aes256`

Parámetro de cifrado que:

- Protege la clave privada con cifrado AES-256
- AES: Advanced Encryption Standard
- 256 bits: tamaño de la clave de cifrado (muy seguro)
- **Importante**: Solicitará una contraseña para proteger la clave

### `-out private/ca-key.pem`

Especifica el archivo de salida:

- **Directorio**: `private/` (carpeta donde se guardará)
- **Nombre**: `ca-key.pem`
- **Formato**: PEM (texto codificado en base64)
- **Prefijo "ca"**: sugiere uso para Certificate Authority (Autoridad Certificadora)

### `4096`

Tamaño de la clave en bits:

- **4096 bits**: nivel de seguridad muy alto
- Más seguro que el estándar 2048 bits
- Genera claves más grandes y operaciones más lentas
- Recomendado para CAs y uso a largo plazo
  
## Resultado del comando

Al ejecutar este comando:

1. **Se solicitará una contraseña** para proteger la clave privada
2. **Se creará el archivo** `private/ca-key.pem`
3. **La clave estará cifrada** con AES-256
4. **Será utilizable** para crear certificados de CA

## 📌 3. Crear el certificado raíz de la CA

```bash
openssl req -new -x509 -days 3650 -key private/ca-key.pem -sha256 -out ca-cert.pem
```

### `openssl`

Misma herramienta de línea de comandos para operaciones criptográficas

### `req`

Subcomando para:

- Gestionar solicitudes de certificados (Certificate Signing Requests - CSR)
- Crear certificados autofirmados
- Procesar y verificar solicitudes de certificados

### `-new`

Indica que se va a:

- Crear una nueva solicitud de certificado
- Generar un nuevo certificado (cuando se combina con -x509)
- Solicitar información del sujeto del certificado

### `-x509`

Parámetro crucial que:

- Crea un certificado X.509 autofirmado
- En lugar de generar solo un CSR, produce un certificado completo
- X.509: estándar para certificados de clave pública
- **Autofirmado**: el certificado es firmado con su propia clave privada

### `-days 3650`

Define la validez del certificado:

- **3650 días** = aproximadamente **10 años**
- Período de validez del certificado
- Después de este tiempo, el certificado expirará
- Valor típico para CAs raíz

### `-key private/ca-key.pem`

Especifica la clave privada a usar:

- **Archivo**: `private/ca-key.pem` (generado en el comando anterior)
- Esta clave firmará el certificado
- Se solicitará la contraseña de la clave privada

### `-sha256`

Algoritmo de hash para la firma:

- **SHA-256**: Secure Hash Algorithm de 256 bits
- Más seguro que SHA-1 (obsoleto)
- Estándar actual recomendado
- Genera la "huella digital" del certificado

### `-out ca-cert.pem`

Archivo de salida del certificado:

- **Nombre**: `ca-cert.pem`
- **Formato**: PEM (texto codificado en base64)
- Certificado público que se puede distribuir
- Contiene la clave pública y metadatos

## Resultado del Comando 2

Al ejecutar este comando:

1. **Se solicitará la contraseña** de la clave privada
2. **Se pedirán datos del certificado**:
    - Country Name (código de país)
    - State/Province Name
    - City/Locality Name
    - Organization Name
    - Organizational Unit Name
    - Common Name (nombre del servidor/CA) Nombre de la CA no del dominio
    - Email Address
3. **Se creará** el archivo `ca-cert.pem`
4. **El certificado será válido por 10 años**

Si llegaste hasta aqui ya tienes tu autoridad certificadora, ahora vamos a crear un certificado para nuestro servidor web