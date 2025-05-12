#!/bin/bash
# Script para arreglar permisos y limpiar archivos de bloqueo

# Colores para salida
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Arreglando permisos del servidor Minecraft ===${NC}"

# Detener el servidor primero
echo -e "${YELLOW}Deteniendo el servidor...${NC}"
docker-compose down

# Crear directorios si no existen
mkdir -p ./data/world
mkdir -p ./data/world_nether
mkdir -p ./data/world_the_end
mkdir -p ./data/plugins

# Eliminar archivos de bloqueo
echo -e "${YELLOW}Eliminando archivos de bloqueo...${NC}"
find ./data -name "session.lock" -type f -delete
find ./data -name "*.lock" -type f -delete

# Arreglar permisos
echo -e "${YELLOW}Configurando permisos...${NC}"
chmod -R 775 ./data
chown -R $USER:$USER ./data

# Reiniciar el servidor
echo -e "${GREEN}Permisos arreglados. Iniciando el servidor...${NC}"
docker-compose up -d

echo -e "${GREEN}¡Completado!${NC}"
echo -e "${YELLOW}Para ver los logs del servidor:${NC}"
echo -e "${BLUE}docker-compose logs -f${NC}"

# Hacer el script ejecutable
chmod +x "$0" 