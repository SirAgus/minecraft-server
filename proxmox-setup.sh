#!/bin/bash
# Script de instalación para servidor Minecraft en Proxmox
# Ejecutar como root

set -e

echo "=== Iniciando configuración de servidor Minecraft para Proxmox ==="

# Verificar que se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse como root"
  exit 1
fi

# Crear directorio de trabajo
INSTALL_DIR="/opt/minecraft-server"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Crear directorios para datos
mkdir -p /var/lib/minecraft/data
mkdir -p /var/lib/minecraft/world

# Instalar dependencias
echo "Instalando dependencias..."
apt-get update
apt-get install -y docker.io docker-compose wget unzip git

# Clonar o copiar archivos del repositorio
if [ -f "docker-compose.yml" ]; then
  echo "Usando archivos existentes en el directorio actual"
  cp -r ./* "$INSTALL_DIR/"
else
  echo "No se encontraron archivos en el directorio actual"
  echo "Por favor, copia manualmente los archivos necesarios al directorio $INSTALL_DIR"
  exit 1
fi

# Crear archivo de mods de ejemplo si no existe
if [ ! -f "/var/lib/minecraft/mods.txt" ]; then
  echo "Creando archivo de mods de ejemplo..."
  cat > /var/lib/minecraft/mods.txt << EOF
# Lista de mods para Minecraft Forge 1.20.1
# Añade o elimina URLs según sea necesario

# JourneyMap (Minimapa)
https://mediafilez.forgecdn.net/files/4582/674/journeymap-1.20.1-5.9.18-forge.jar

# Just Enough Items (JEI)
https://mediafilez.forgecdn.net/files/4978/962/jei-1.20.1-forge-15.3.0.4.jar
EOF
fi

echo "=== Configuración completada ==="
echo ""
echo "Directorios creados:"
echo "- $INSTALL_DIR (archivos del servidor)"
echo "- /var/lib/minecraft/data (datos del servidor)"
echo "- /var/lib/minecraft/world (mundo de Minecraft)"
echo ""
echo "Para usar un mundo predefinido:"
echo "1. Copia los archivos de tu mundo existente a /var/lib/minecraft/world"
echo "2. Asegúrate de que los archivos pertenezcan al usuario correcto:"
echo "   chown -R 1000:1000 /var/lib/minecraft/world"
echo ""
echo "Para iniciar el servidor:"
echo "cd $INSTALL_DIR && docker-compose up -d"
echo ""
echo "Para ver los logs del servidor:"
echo "docker logs -f minecraft-server" 