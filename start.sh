#!/bin/bash
set -e

# Imprimir información para depuración
echo "Iniciando servidor Minecraft..."
echo "SERVER_PORT: $SERVER_PORT"
echo "GEYSER_PORT: $GEYSER_PORT"
echo "MEMORIA: $MEMORY"

# Ejecutar el comando de inicio original
exec /start 