#!/bin/bash
# Script para la configuración de mods y add-ons

# Colores para salida
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Configuración de Mods y Add-ons para Minecraft ===${NC}"

# Crear directorios necesarios si no existen
mkdir -p ./data/mods
mkdir -p ./data/config
mkdir -p ./data/plugins
mkdir -p ./data/addons

# Instalar Fabric API (mod esencial para casi todos los mods de Fabric)
echo -e "${YELLOW}Instalando Fabric API...${NC}"
wget -O ./data/mods/fabric-api.jar https://cdn.modrinth.com/data/P7dR8mSH/versions/O9s0isbH/fabric-api-0.91.0%2B1.20.4.jar

# Instalar Geyser y Floodgate específicos
echo -e "${YELLOW}Configurando Geyser y Floodgate...${NC}"
# No necesitamos descargarlos manualmente ya que los configuramos en docker-compose.yml

# Crear archivo para añadir mods adicionales en el futuro
cat > add-mod.sh << 'EOL'
#!/bin/bash
if [ -z "$1" ]; then
  echo "Uso: ./add-mod.sh [URL del mod]"
  exit 1
fi

mkdir -p ./data/mods
wget -O ./data/mods/$(basename $1) $1
echo "Mod descargado. Reinicia el servidor para aplicar cambios."
EOL
chmod +x add-mod.sh

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
docker-compose up -d

echo -e "${GREEN}Configuración completada${NC}"
echo -e "${YELLOW}Instrucciones:${NC}"
echo -e "1. Para añadir un mod: ${BLUE}./add-mod.sh [URL del mod]${NC}"
echo -e "2. Para añadir un add-on de Bedrock: ${BLUE}./add-addon.sh [URL del addon]${NC}"
echo -e "3. Para ver los logs del servidor: ${BLUE}docker-compose logs -f${NC}"
echo -e "4. Para detener el servidor: ${BLUE}docker-compose down${NC}"
echo -e "5. Para reiniciar el servidor: ${BLUE}docker-compose restart${NC}"
echo -e ""
echo -e "${YELLOW}Información de conexión:${NC}"
echo -e "1. Java: IP del servidor, puerto 25565"
echo -e "2. Bedrock: IP del servidor, puerto 19132"

# Hacer el script ejecutable
chmod +x "$0" 