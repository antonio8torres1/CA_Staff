#!/bin/bash

# Función para generar certificado
generar_certificado() {
  local DOMINIO=$1

  echo "=== Generando certificado para: ${DOMINIO} ==="

  # Modificar solo el commonName en la sección req_distinguished_name
  sed -i "/^\[ req_distinguished_name \]/,/^\[/ s/^commonName[[:space:]]*=.*/commonName                      = ${DOMINIO}/" openssl.cnf

  # 1. Crear la clave privada para el servidor
  openssl genrsa -out private/${DOMINIO}-key.pem 2048

  # 2. Crear la solicitud de firma (CSR)
  openssl req -config openssl.cnf -key private/${DOMINIO}-key.pem -new -sha256 -out csrs/${DOMINIO}.csr

  # 3. Firmar el certificado con tu CA
  openssl ca -config openssl.cnf -extensions server_cert -days 365 -notext -md sha256 -in csrs/${DOMINIO}.csr -out certs/${DOMINIO}-cert.pem -batch

  echo "=== Certificado para ${DOMINIO} generado exitosamente ==="
  echo ""
}

# Verificar que se proporcione al menos un argumento
if [ -z "$1" ]; then
  echo "Error: Debes proporcionar un dominio o archivo de dominios"
  echo "Uso: $0 <dominio>"
  echo "Uso: $0 -f <archivo_dominios.txt>"
  exit 1
fi

# Verificar si se usa la opción -f para archivo
if [ "$1" == "-f" ]; then
  if [ -z "$2" ]; then
    echo "Error: Debes proporcionar el archivo de dominios"
    echo "Uso: $0 -f <archivo_dominios.txt>"
    exit 1
  fi

  ARCHIVO=$2

  if [ ! -f "$ARCHIVO" ]; then
    echo "Error: El archivo $ARCHIVO no existe"
    exit 1
  fi

  # Leer el archivo línea por línea
  while IFS= read -r DOMINIO || [ -n "$DOMINIO" ]; do
    # Ignorar líneas vacías y comentarios
    if [ -n "$DOMINIO" ] && [[ ! "$DOMINIO" =~ ^[[:space:]]*# ]]; then
      generar_certificado "$DOMINIO"
    fi
  done <"$ARCHIVO"
else
  # Modo individual
  DOMINIO=$1
  generar_certificado "$DOMINIO"
fi
