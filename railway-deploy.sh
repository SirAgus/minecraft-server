#!/bin/bash

# Verifica si docker-compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "Instalando docker-compose..."
    pip install docker-compose
fi

# Crea un archivo de configuración para Railway sin usar volúmenes
echo "Usando configuración especial para Railway..."
docker-compose -f railway-compose.yml up 