#!/bin/bash
# Script para instalar Geyser y Floodgate manualmente

# Colores para salida
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Instalando Geyser y Floodgate para soporte de Bedrock ===${NC}"

# Crear directorios necesarios
mkdir -p ./data/plugins

# Descargar Geyser (versión spigot)
echo -e "${YELLOW}Descargando Geyser-Spigot...${NC}"
wget -O ./data/plugins/Geyser-Spigot.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot

# Descargar Floodgate (versión spigot)
echo -e "${YELLOW}Descargando Floodgate-Spigot...${NC}"
wget -O ./data/plugins/floodgate-spigot.jar https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot

# Configurar Geyser
mkdir -p ./data/plugins/Geyser-Spigot
cat > ./data/plugins/Geyser-Spigot/config.yml << EOL
# Configuración básica de Geyser
bedrock:
  address: 0.0.0.0
  port: 19132
  clone-remote-port: false
  motd1: "Servidor Minecraft"
  motd2: "¡Java y Bedrock juntos!"
  server-name: "Minecraft Server"
remote:
  address: 127.0.0.1
  port: 25565
  auth-type: floodgate
EOL

echo -e "${GREEN}Instalación completada${NC}"
echo -e "${YELLOW}Ahora puedes reiniciar el servidor para aplicar los cambios:${NC}"
echo -e "${BLUE}docker-compose restart${NC}"

# Hacer el script ejecutable
chmod +x "$0" 