#!/bin/bash
# Script para instalar Geyser y Floodgate manualmente

# Colores para salida
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Instalación manual de Geyser y Floodgate ===${NC}"

# Detener el servidor
echo -e "${YELLOW}Deteniendo el servidor...${NC}"
docker-compose down

# Esperar a que se detenga completamente
sleep 5

# Crear directorio de plugins
echo -e "${YELLOW}Creando directorio de plugins...${NC}"
mkdir -p /var/lib/minecraft/data/plugins

# Descargar las últimas versiones de Geyser y Floodgate
echo -e "${YELLOW}Descargando Geyser y Floodgate...${NC}"
cd /var/lib/minecraft/data/plugins/

# Eliminar versiones antiguas
rm -f Geyser-Spigot.jar Floodgate-Spigot.jar
rm -rf Geyser-Spigot/ floodgate/

# Descargar la última versión de Geyser para Spigot
echo -e "${YELLOW}Descargando Geyser para Spigot...${NC}"
wget -O Geyser-Spigot.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot

# Descargar la última versión de Floodgate para Spigot
echo -e "${YELLOW}Descargando Floodgate para Spigot...${NC}"
wget -O Floodgate-Spigot.jar https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot

# Verificar que se hayan descargado los archivos
echo -e "${YELLOW}Verificando archivos descargados...${NC}"
ls -la *.jar

# Actualizar docker-compose.yml para usar los plugins manuales
echo -e "${YELLOW}Actualizando docker-compose.yml...${NC}"
cd /root/minecraft-server
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
      - GEYSER=false
      - FLOODGATE=false
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
echo -e "${YELLOW}Iniciando el servidor con plugins manuales...${NC}"
docker-compose up -d

# Esperar a que inicie
echo -e "${YELLOW}Esperando a que el servidor inicie (60 segundos)...${NC}"
sleep 60

# Verificar que los plugins estén cargados
echo -e "${YELLOW}Verificando plugins cargados...${NC}"
docker exec -it minecraft-server ls -la /data/plugins/

# Verificar que los puertos estén abiertos
echo -e "${YELLOW}Verificando puertos abiertos...${NC}"
netstat -tulpn | grep -E '25565|25566|19132'

echo -e "${GREEN}Instalación completada${NC}"
echo -e "${YELLOW}Instrucciones para conexión:${NC}"
echo -e "1. IP del servidor Minecraft Java: ${BLUE}192.168.1.3:25565${NC}"
echo -e "2. IP del servidor Minecraft Bedrock: ${BLUE}192.168.1.3${NC} Puerto: ${BLUE}25566${NC}"
echo -e ""
echo -e "${YELLOW}Para verificar los logs completos:${NC}"
echo -e "${BLUE}docker logs -f minecraft-server${NC}"
echo -e ""
echo -e "${YELLOW}Para verificar si Geyser está cargado:${NC}"
echo -e "${BLUE}docker exec -it minecraft-server grep -i 'geyser' /data/logs/latest.log${NC}"

# Hacer el script ejecutable
chmod +x "$0" 