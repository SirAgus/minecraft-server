#!/bin/bash
# Script para actualizar el servidor Minecraft a una nueva versión

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function mostrar_ayuda {
  echo -e "${YELLOW}Uso: $0 [java|bedrock] [versión]${NC}"
  echo ""
  echo "Ejemplos:"
  echo "  $0 java 1.21.4    - Actualiza a Minecraft Java 1.21.4"
  echo "  $0 bedrock latest - Actualiza a la última versión de Bedrock"
  echo ""
}

# Verificar argumentos
if [ "$#" -lt 2 ]; then
  mostrar_ayuda
  exit 1
fi

TIPO="$1"
VERSION="$2"
DOCKERFILE="Dockerfile"
COMPOSE="docker-compose.yml"

# Validar tipo
if [[ "$TIPO" != "java" && "$TIPO" != "bedrock" ]]; then
  echo -e "${RED}Error: El tipo debe ser 'java' o 'bedrock'${NC}"
  mostrar_ayuda
  exit 1
fi

# Backup de archivos originales
echo -e "${YELLOW}Creando respaldo de archivos de configuración...${NC}"
cp $DOCKERFILE ${DOCKERFILE}.bak
cp $COMPOSE ${COMPOSE}.bak

# Actualizar versión
if [ "$TIPO" == "java" ]; then
  echo -e "${GREEN}Actualizando versión de Minecraft Java a $VERSION${NC}"
  
  # Actualizar Dockerfile
  sed -i "s/ENV VERSION=.*/ENV VERSION=$VERSION/" $DOCKERFILE
  
  # Actualizar docker-compose.yml
  sed -i "s/- VERSION=.*/- VERSION=$VERSION/" $COMPOSE
  
  # Buscar mods compatibles con la nueva versión
  echo -e "${YELLOW}Buscando mods compatibles con la versión $VERSION...${NC}"
  
  # Esta parte es informativa, indicaría a los usuarios que actualicen los mods manualmente
  echo -e "${YELLOW}IMPORTANTE: Debes actualizar manualmente los mods en el Dockerfile:${NC}"
  echo "1. Edita el archivo $DOCKERFILE"
  echo "2. Busca la sección '# Crear archivo de mods'"
  echo "3. Actualiza las URLs de los mods a versiones compatibles con Minecraft $VERSION"
  
elif [ "$TIPO" == "bedrock" ]; then
  echo -e "${GREEN}Actualizando soporte de Minecraft Bedrock a $VERSION${NC}"
  
  # Actualizar README.md
  sed -i "s/Bedrock [0-9]\+\.[0-9]\+\.[0-9]\+/Bedrock $VERSION/g" README.md
  
  echo -e "${YELLOW}NOTA: El soporte de Bedrock se gestiona a través de Geyser, que se actualiza automáticamente.${NC}"
  echo -e "${YELLOW}No es necesario modificar nada más para soporte de Bedrock.${NC}"
fi

# Reconstruir la imagen
echo -e "${GREEN}Reconstruyendo el servidor con la nueva versión...${NC}"
echo -e "${YELLOW}Para aplicar los cambios, ejecuta:${NC}"
echo "docker-compose down"
echo "docker-compose build --no-cache"
echo "docker-compose up -d"

echo -e "${GREEN}¡Actualización completada!${NC}"
exit 0 