#!/bin/bash
# Script para reiniciar completamente el servidor y configurarlo desde cero

# Colores para salida
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Reiniciando servidor Minecraft desde cero ===${NC}"
echo -e "${RED}¡ADVERTENCIA! Este script eliminará todos los datos existentes del servidor.${NC}"
echo -e "${RED}Cualquier mundo o configuración previa se perderá.${NC}"
read -p "¿Estás seguro de continuar? (s/n): " confirm

if [ "$confirm" != "s" ]; then
    echo -e "${YELLOW}Operación cancelada.${NC}"
    exit 1
fi

# Detener el servidor primero
echo -e "${YELLOW}Deteniendo el servidor...${NC}"
docker-compose down

# Eliminar todos los datos existentes
echo -e "${YELLOW}Eliminando datos existentes...${NC}"
rm -rf ./data

# Crear directorios necesarios
echo -e "${YELLOW}Creando estructura de directorios...${NC}"
mkdir -p ./data/world
mkdir -p ./data/world_nether
mkdir -p ./data/world_the_end
mkdir -p ./data/plugins
mkdir -p ./data/config
mkdir -p ./data/addons

# Configurar permisos
echo -e "${YELLOW}Configurando permisos...${NC}"
chmod -R 777 ./data

# Iniciar el servidor
echo -e "${YELLOW}Iniciando el servidor...${NC}"
docker-compose up -d

# Esperar a que el servidor se inicie
echo -e "${YELLOW}Esperando a que el servidor se inicie (30 segundos)...${NC}"
sleep 30

# Instalar Geyser para soporte de Bedrock
echo -e "${YELLOW}Instalando Geyser y Floodgate...${NC}"
./install-geyser.sh

# Reiniciar el servidor con todos los plugins
echo -e "${YELLOW}Reiniciando el servidor con todos los plugins...${NC}"
docker-compose restart

echo -e "${GREEN}¡Configuración completada!${NC}"
echo -e "${YELLOW}Para ver los logs del servidor:${NC}"
echo -e "${BLUE}docker-compose logs -f${NC}"
echo -e ""
echo -e "${YELLOW}Información de conexión:${NC}"
echo -e "1. Java: IP del servidor, puerto 25565"
echo -e "2. Bedrock: IP del servidor, puerto 19132"

# Hacer el script ejecutable
chmod +x "$0" 