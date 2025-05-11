#!/bin/bash
# Script para preparar un mundo existente para ser usado en el servidor Minecraft

set -e

MUNDO_SRC="$1"
MUNDO_DEST="/var/lib/minecraft/world"

# Verificar argumentos
if [ -z "$MUNDO_SRC" ]; then
  echo "Uso: $0 <ruta-al-mundo>"
  echo "Ejemplo: $0 ./mi-mundo.zip"
  exit 1
fi

# Crear directorio de destino
mkdir -p "$MUNDO_DEST"

# Procesar según el tipo de archivo
if [[ "$MUNDO_SRC" == *.zip ]]; then
  echo "Descomprimiendo archivo ZIP..."
  unzip -o "$MUNDO_SRC" -d "$MUNDO_DEST"
elif [[ "$MUNDO_SRC" == *.tar.gz ]] || [[ "$MUNDO_SRC" == *.tgz ]]; then
  echo "Descomprimiendo archivo TAR.GZ..."
  tar -xzf "$MUNDO_SRC" -C "$MUNDO_DEST"
elif [ -d "$MUNDO_SRC" ]; then
  echo "Copiando directorio..."
  cp -r "$MUNDO_SRC"/* "$MUNDO_DEST"/
else
  echo "Formato no soportado. Por favor proporciona un archivo ZIP, TAR.GZ o un directorio."
  exit 1
fi

# Asignar permisos correctos
if [ "$EUID" -eq 0 ]; then
  echo "Estableciendo permisos..."
  chown -R 1000:1000 "$MUNDO_DEST"
  chmod -R 755 "$MUNDO_DEST"
else
  echo "ADVERTENCIA: No se pudieron establecer los permisos adecuados porque no eres root."
  echo "Ejecuta: sudo chown -R 1000:1000 $MUNDO_DEST"
fi

echo "Mundo preparado en $MUNDO_DEST"
echo "Contenido:"
ls -la "$MUNDO_DEST"

echo "¡Listo! Ahora puedes iniciar el servidor con: docker-compose up -d" 