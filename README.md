# CA Staff - Certificados TLS con OpenSSL

Herramienta y documentación para crear y gestionar certificados TLS/SSL usando OpenSSL.

## Estructura

- `docs/` - Documentación en Markdown y scripts de automatización
- `certificados/` - Certificados generados
- `build/` - Sitio web de documentación (Docusaurus)

## Documentación Web

Visita la documentación completa en: [https://antonio8torres1.github.io/CA_Staff/](https://antonio8torres1.github.io/CA_Staff/)

## Uso Rápido

```bash
# Generar certificado individual
cd docs/scripts
./ca.sh ejemplo.com

# Generar múltiples certificados
./ca.sh -f dominios.txt
```

## Requisitos

- OpenSSL
- Bash

---

Documentación académica sobre certificados TLS/SSL
