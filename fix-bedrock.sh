#!/bin/bash
# Script para solucionar problemas de conexión Bedrock

# Colores para salida
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Diagnóstico y solución de problemas para Bedrock ===${NC}"

# Detener el servidor
echo -e "${YELLOW}Deteniendo el servidor...${NC}"
docker-compose down

# Esperar a que se detenga completamente
sleep 5

# Verificar la configuración actual
echo -e "${YELLOW}Verificando configuración actual...${NC}"
cat docker-compose.yml | grep -E "GEYSER|FLOODGATE|ports|TYPE"

# Eliminar configuraciones antiguas de Geyser/Floodgate
echo -e "${YELLOW}Limpiando configuraciones antiguas de Geyser/Floodgate...${NC}"
rm -rf /var/lib/minecraft/data/plugins/Geyser-Spigot
rm -rf /var/lib/minecraft/data/plugins/floodgate
rm -rf /var/lib/minecraft/data/plugins/geyser

# Configurar docker-compose.yml optimizado para Bedrock
echo -e "${YELLOW}Actualizando docker-compose.yml para optimizar conexión Bedrock...${NC}"
cat > docker-compose.yml << EOL
version: '3'

services:
  minecraft:
    image: itzg/minecraft-server:java21
    container_name: minecraft-server
    ports:
      - "25565:25565"
      - "25566:19132/udp"
    environment:
      - MEMORY=6G
      - VERSION=1.20.4
      - TYPE=PAPER
      - EULA=TRUE
      - SERVER_PORT=25565
      - DIFFICULTY=normal
      - ALLOW_NETHER=true
      - ENABLE_COMMAND_BLOCK=true
      - LEVEL_TYPE=default
      - PVP=true
      - MAX_PLAYERS=20
      - VIEW_DISTANCE=8
      - SIMULATION_DISTANCE=6
      - SPAWN_PROTECTION=16
      - OVERRIDE_SERVER_PROPERTIES=true
      - ONLINE_MODE=false
      - GEYSER=true
      - FLOODGATE=true
      - GEYSER_PORT=25566
    volumes:
      - /var/lib/minecraft/data:/data
      - /var/lib/minecraft/world:/data/world
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 7G
        reservations:
          memory: 4G
EOL

# Iniciar el servidor
echo -e "${YELLOW}Iniciando el servidor con la configuración optimizada...${NC}"
docker-compose up -d

# Esperar a que inicie
echo -e "${YELLOW}Esperando a que el servidor inicie (60 segundos)...${NC}"
sleep 60

# Verificar que los puertos estén correctamente abiertos
echo -e "${YELLOW}Verificando puertos abiertos...${NC}"
netstat -tulpn | grep -E '25565|25566|19132'

# Verificar logs específicos de Geyser
echo -e "${YELLOW}Verificando logs de Geyser...${NC}"
docker logs minecraft-server | grep -i "geyser\|bedrock\|floodgate" | tail -n 20

# Verificar que el contenedor esté usando la configuración correcta
echo -e "${YELLOW}Verificando configuración del contenedor...${NC}"
docker inspect minecraft-server | grep -A 5 -E "25566|19132"

echo -e "${GREEN}Diagnóstico completado${NC}"
echo -e "${YELLOW}Instrucciones para conexión Bedrock:${NC}"
echo -e "1. La IP del servidor es: ${BLUE}192.168.1.3${NC}"
echo -e "2. El puerto para Bedrock es: ${BLUE}25566${NC} (asegúrate de usar este puerto específico)"
echo -e "3. Espera 2-3 minutos después de que el servidor esté online para intentar conectarte"
echo -e "4. Si sigues sin poder conectarte, intenta reiniciar el cliente Bedrock"
echo -e ""
echo -e "${YELLOW}Verificación avanzada:${NC}"
echo -e "Si los pasos anteriores no funcionan, ejecuta:"
echo -e "${BLUE}docker logs -f minecraft-server | grep -i geyser${NC}"
echo -e "Y busca cualquier mensaje de error específico."

# Hacer el script ejecutable
chmod +x "$0" 