## ¿Qué es HTTP?

**HTTP** (Hypertext Transfer Protocol - Protocolo de Transferencia de Hipertexto) es el protocolo fundamental de comunicación en la web. Define cómo se envían y reciben los mensajes entre navegadores y servidores web.

**Características principales:**

- Funciona en texto plano sin cifrado
- Opera en el puerto 80 por defecto
- Los datos viajan sin protección, pudiendo ser interceptados
- Vulnerable a ataques de tipo "man-in-the-middle"

## ¿Qué es HTTPS?

**HTTPS** (HTTP Secure) es la versión segura de HTTP. Utiliza cifrado para proteger la información transmitida entre el navegador y el servidor.

**Ventajas de HTTPS:**

- Cifra todos los datos transmitidos
- Verifica la identidad del servidor
- Protege la integridad de los datos
- Opera en el puerto 443 por defecto
- Mejora el posicionamiento SEO
- Genera confianza en los usuarios (candado en el navegador)

## ¿Qué es TLS?

**TLS** (Transport Layer Security - Seguridad de la Capa de Transporte) es el protocolo de seguridad moderno que cifra las comunicaciones entre clientes y servidores en internet. Es el sucesor de SSL (Secure Sockets Layer), aunque comúnmente se sigue usando el término "SSL" por razones históricas.

**Versiones de TLS:**

- TLS 1.0 (1999) - Descontinuado, inseguro
- TLS 1.1 (2006) - Descontinuado, inseguro
- TLS 1.2 (2008) - Ampliamente usado, seguro
- TLS 1.3 (2018) - Versión actual, más rápida y segura

**Mejoras de TLS 1.3:**

- Handshake más rápido (menos latencia)
- Cifrados más seguros (elimina algoritmos débiles)
- Mejor privacidad (cifra más partes del handshake)
- Simplificación del protocolo

## ¿Qué es un Certificado TLS?

Un **certificado TLS** (comúnmente llamado certificado SSL por razones históricas) es un archivo digital que contiene información sobre la identidad de un sitio web y su clave pública. Funciona como una "identificación digital" que permite:

- Autenticar la identidad del sitio web
- Habilitar conexiones cifradas
- Garantizar que te estás conectando al servidor correcto

**Componentes de un certificado TLS:**

- Nombre de dominio del sitio
- Información de la organización propietaria
- Clave pública
- Fecha de emisión y expiración
- Firma digital de la Autoridad Certificadora
- Detalles técnicos del algoritmo de cifrado
- Versión del certificado (X.509)

## ¿Cómo Funciona un Certificado TLS?

El proceso de establecimiento de una conexión HTTPS se llama "handshake TLS":

### Proceso paso a paso:

1. **Cliente inicia conexión:** El navegador se conecta a un sitio web con HTTPS y envía un mensaje "Client Hello" indicando las versiones de TLS y cifrados que soporta.
2. **Servidor responde:** El servidor envía un "Server Hello" seleccionando la versión de TLS y el cifrado a usar, junto con su certificado TLS que contiene la clave pública.
3. **Verificación del certificado:** El navegador verifica:
   - Que el certificado sea emitido por una Autoridad Certificadora confiable
   - Que no haya expirado
   - Que el dominio coincida con el del certificado
   - Que no esté revocado
   - Que la cadena de certificados sea válida

4. **Intercambio de claves:** Si el certificado es válido, cliente y servidor generan claves de sesión usando algoritmos como ECDHE (Elliptic Curve Diffie-Hellman Ephemeral) que proporcionan Perfect Forward Secrecy.
5. **Establecimiento de sesión:** Ambas partes confirman que tienen las mismas claves de sesión.
6. **Comunicación cifrada:** Todos los datos se cifran con cifrados simétricos rápidos (como AES-GCM) usando las claves de sesión acordadas.

**Analogía:** Es como acordar un idioma secreto. El servidor te muestra su credencial (certificado), verificas que es legítima, luego ambos acuerdan un código secreto único para esa conversación que nadie más puede descifrar.

## ¿Qué es una Autoridad Certificadora (CA)?

Una **Autoridad Certificadora** (Certificate Authority - CA) es una organización confiable que emite, valida y gestiona certificados digitales TLS.

**Ejemplos de CAs reconocidas:**

- Let's Encrypt (gratuita, automatizada)
- DigiCert
- GlobalSign
- Sectigo (anteriormente Comodo)
- Google Trust Services
- Amazon Trust Services

**Funciones de una CA:**

- Verificar la identidad del solicitante del certificado
- Emitir certificados digitales firmados
- Mantener registros de certificados emitidos
- Revocar certificados comprometidos o inválidos
- Publicar listas de certificados revocados (CRL) y responder consultas OCSP
- Mantener la seguridad de sus claves privadas raíz

## ¿Cómo Ayuda Firmar Certificados?

La **firma digital** de una Autoridad Certificadora es fundamental para la seguridad de HTTPS:

### Cadena de Confianza

Los certificados funcionan mediante una "cadena de confianza":

1. **Certificados raíz:** Los navegadores y sistemas operativos vienen preinstalados con certificados de CAs confiables (certificados raíz). Estos están en "trust stores" o almacenes de confianza.
2. **Certificados intermedios:** Las CAs no firman directamente con su certificado raíz (que mantienen altamente protegido). Usan certificados intermedios que están firmados por el raíz.
3. **Certificado del servidor:** Tu certificado web está firmado por un certificado intermedio.
4. **Verificación en cadena:** El navegador verifica:
   - Tu certificado fue firmado por el intermedio
   - El intermedio fue firmado por el raíz
   - El raíz está en su trust store

### Beneficios de la firma de certificados:

**Autenticidad:** La firma garantiza que el certificado fue realmente emitido por esa CA y no ha sido falsificado.

**Integridad:** Cualquier modificación al certificado después de ser firmado invalidará la firma, alertando al navegador de una posible manipulación.

**No repudio:** La CA no puede negar haber emitido ese certificado, ya que su firma criptográfica lo demuestra.

**Confianza distribuida:** No necesitas conocer cada sitio web individualmente; confías en la CA, y ella valida los sitios por ti.

**Revocación:** Si un certificado se compromete, la CA puede revocarlo y los navegadores pueden verificar su estado en tiempo real.

### Ejemplo práctico:

Imagina que compras algo en una tienda online:

- Sin firma CA: Cualquiera podría crear un certificado falso diciendo "soy Amazon" y robar tus datos.
- Con firma CA: El navegador verifica que una autoridad confiable (como DigiCert) verificó que ese sitio es realmente Amazon antes de emitir el certificado, y que la cadena completa de firmas es válida.

## Tipos de Certificados TLS

**Domain Validation (DV):** Verifica solo la propiedad del dominio mediante desafíos automatizados (DNS o HTTP). Emisión rápida, ideal para blogs y sitios personales.

**Organization Validation (OV):** Verifica la organización además del dominio. La CA valida documentos legales de la empresa. Proporciona más confianza.

**Extended Validation (EV):** Verificación exhaustiva de la organización con procesos rigurosos. Anteriormente mostraba el nombre de la empresa en verde en la barra del navegador (los navegadores modernos lo muestran de forma diferente).

**Wildcard:** Protege un dominio y todos sus subdominios de primer nivel (\*.ejemplo.com cubre www.ejemplo.com, api.ejemplo.com, etc.).

**Multi-Domain (SAN):** Protege múltiples dominios diferentes con un solo certificado usando Subject Alternative Names.

## Certificados Autofirmados

Un **certificado autofirmado** es aquel que no está firmado por una Autoridad Certificadora reconocida, sino por el propio emisor. El servidor firma su propio certificado.

**Casos de uso legítimos:**

- Entornos de desarrollo y pruebas locales
- Redes internas corporativas (intranets)
- Dispositivos IoT en redes privadas
- Aprendizaje y experimentación

**Limitaciones:**

- Los navegadores mostrarán advertencias de seguridad
- No son confiables para sitios públicos en internet
- No hay validación de identidad por terceros
- No se pueden revocar de manera estándar
- Los usuarios deben aceptar manualmente la excepción de seguridad

**Cuándo NO usar certificados autofirmados:**

- Sitios web públicos o de producción
- Aplicaciones que manejan datos sensibles accesibles por internet
- Comercio electrónico
- Cualquier servicio que requiera confianza del usuario

# Certificados Autofirmados con OpenSSL

## ¿Qué es OpenSSL?

**OpenSSL** es una biblioteca de software de código abierto que implementa los protocolos TLS y SSL, además de proporcionar herramientas de línea de comandos para trabajar con certificados, claves y cifrado.

**Usos principales:**

- Generar claves privadas y públicas
- Crear solicitudes de firma de certificados (CSR)
- Generar certificados autofirmados
- Verificar y analizar certificados
- Cifrar y descifrar datos
- Calcular hashes criptográficos
