# Servidor de Minecraft Crossplay

Este es un servidor de Minecraft que permite jugar tanto desde la versión Java como desde la versión Bedrock (móvil, consolas, Windows 10/11), diseñado para ser desplegado en Railway.

## Características

- Soporte para Minecraft Java Edition
- Soporte para Minecraft Bedrock Edition (crossplay)
- Optimizado para Railway
- Fácil despliegue con un solo clic
- Configuración personalizable a través de variables de entorno

## Variables de entorno

| Variable | Descripción | Valor predeterminado |
|----------|-------------|----------------------|
| MINECRAFT_VERSION | Versión de Minecraft a utilizar | 1.20.4 |
| MEMORY | Memoria asignada al servidor | 1G |
| SERVER_PORT | Puerto para la versión Java | 25565 |
| GEYSER_PORT | Puerto para la versión Bedrock | 19132 |

## Despliegue en Railway

1. Crea una cuenta en [Railway](https://railway.app/)
2. Haz clic en el botón de despliegue a continuación:

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/minecraft-crossplay)

Alternativamente, puedes desplegar manualmente:

1. Crea un nuevo proyecto en Railway
2. Selecciona "Deploy from GitHub repo"
3. Conecta tu repositorio de GitHub
4. Railway detectará el Dockerfile automáticamente
5. Configura las variables de entorno necesarias
6. Despliega el proyecto

## Conexión al servidor

### Java Edition
- Conéctate usando la dirección proporcionada por Railway con el puerto 25565 (o el que hayas configurado)

### Bedrock Edition (móvil, consolas, Windows 10/11)
- Conéctate usando la dirección proporcionada por Railway con el puerto 19132 (o el que hayas configurado)
- Nota: Para Bedrock, es posible que debas usar el formato `direccion:puerto`

## Mantenimiento

Los datos del servidor se almacenan en el contenedor. Para persistencia a largo plazo, considera configurar un volumen de almacenamiento en Railway. 