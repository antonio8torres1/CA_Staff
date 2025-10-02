#!/bin/bash

# Verificar que se proporcione el dominio
if [ -z "$1" ]; then
  echo "Error: Debes proporcionar un dominio"
  echo "Uso: $0 <dominio>"
  exit 1
fi

DOMINIO=$1

sed -i "/^\[ req_distinguished_name \]/,/^\[/ s/^commonName[[:space:]]*=.*/commonName                      = ${DOMINIO}/" openssl.cnf

# 1. Crear la clave privada para el servidor
openssl genrsa -out private/${DOMINIO}-key.pem 2048

# 2. Crear la solicitud de firma (CSR)
openssl req -config openssl.cnf -key private/${DOMINIO}-key.pem -new -sha256 -out ${DOMINIO}.csr

# 3. Firmar el certificado con tu CA
openssl ca -config openssl.cnf -extensions server_cert -days 365 -notext -md sha256 -in ${DOMINIO}.csr -out certs/${DOMINIO}-cert.pem
