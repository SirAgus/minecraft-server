#!/bin/bash
# Script para la configuración de mods y add-ons

# Colores para salida
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Configuración de Plugins y Add-ons para Minecraft ===${NC}"

# Crear directorios necesarios si no existen
mkdir -p ./data/plugins
mkdir -p ./data/config
mkdir -p ./data/addons

# Crear directorios para el servidor
mkdir -p ./data/world
mkdir -p ./data/world_nether
mkdir -p ./data/world_the_end

# No necesitamos instalar Fabric API ya que usamos Paper

# Crear archivo para añadir plugins adicionales
cat > add-plugin.sh << 'EOL'
#!/bin/bash
if [ -z "$1" ]; then
  echo "Uso: ./add-plugin.sh [URL del plugin]"
  exit 1
fi

mkdir -p ./data/plugins
wget -O ./data/plugins/$(basename $1) $1
echo "Plugin descargado. Reinicia el servidor para aplicar cambios."
EOL
chmod +x add-plugin.sh

# Crear archivo para añadir add-ons de Bedrock
cat > add-addon.sh << 'EOL'
#!/bin/bash
if [ -z "$1" ]; then
  echo "Uso: ./add-addon.sh [URL del addon .mcpack o .mcaddon]"
  exit 1
fi

mkdir -p ./data/addons
wget -O ./data/addons/$(basename $1) $1
echo "Add-on descargado. Reinicia el servidor para aplicar cambios."
EOL
chmod +x add-addon.sh

# Iniciar el servidor
echo -e "${YELLOW}Iniciando el servidor...${NC}"
docker-compose down
docker-compose up -d

echo -e "${GREEN}Configuración inicial completada${NC}"
echo -e "${YELLOW}Para habilitar soporte de Bedrock, ejecuta:${NC}"
echo -e "${BLUE}./install-geyser.sh${NC}"
echo -e ""
echo -e "${YELLOW}Instrucciones:${NC}"
echo -e "1. Para añadir un plugin: ${BLUE}./add-plugin.sh [URL del plugin]${NC}"
echo -e "2. Para añadir un add-on de Bedrock: ${BLUE}./add-addon.sh [URL del addon]${NC}"
echo -e "3. Para ver los logs del servidor: ${BLUE}docker-compose logs -f${NC}"
echo -e "4. Para detener el servidor: ${BLUE}docker-compose down${NC}"
echo -e "5. Para reiniciar el servidor: ${BLUE}docker-compose restart${NC}"
echo -e ""
echo -e "${YELLOW}Información de conexión:${NC}"
echo -e "1. Java: IP del servidor, puerto 25565"
echo -e "2. Bedrock (después de instalar Geyser): IP del servidor, puerto 19132"

# Hacer el script ejecutable
chmod +x "$0" 