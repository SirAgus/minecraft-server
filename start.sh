#!/bin/bash
# Script de inicio rápido para el servidor Minecraft

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Iniciando Servidor Minecraft Java + Bedrock ===${NC}"

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker no está instalado. Instálalo primero.${NC}"
    exit 1
fi

# Verificar si Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Docker Compose no está instalado. Instálalo primero.${NC}"
    exit 1
fi

# Verificar si ya se ha configurado el servidor
if [ ! -d "./data/mods" ]; then
    echo -e "${YELLOW}Configuración inicial no detectada. Ejecutando setup-mods.sh...${NC}"
    chmod +x setup-mods.sh
    ./setup-mods.sh
else
    # Iniciar el servidor si ya está configurado
    echo -e "${YELLOW}Iniciando el servidor...${NC}"
    docker-compose up -d
    
    echo -e "${GREEN}¡Servidor iniciado!${NC}"
    echo -e "${YELLOW}Información de conexión:${NC}"
    echo -e "1. Java: IP del servidor, puerto 25565"
    echo -e "2. Bedrock: IP del servidor, puerto 19132"
    echo -e ""
    echo -e "Para ver los logs: ${BLUE}docker-compose logs -f${NC}"
    echo -e "Para detener el servidor: ${BLUE}docker-compose down${NC}"
fi

# Hacer el script ejecutable
chmod +x "$0" 