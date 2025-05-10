# Servidor de Minecraft Crossplay

Este es un servidor de Minecraft que permite jugar tanto desde la versión Java como desde la versión Bedrock (móvil, consolas, Windows 10/11), diseñado para ser desplegado en Railway.

## Características

- Soporte para Minecraft Java Edition
- Soporte para Minecraft Bedrock Edition (crossplay)
- Actualización automática a la última build estable de Paper
- Optimizado para Railway
- Fácil despliegue con un solo clic
- Configuración personalizable a través de variables de entorno

## Variables de entorno

| Variable | Descripción | Valor predeterminado |
|----------|-------------|----------------------|
| MINECRAFT_VERSION | Versión de Minecraft a utilizar | 1.21.4 |
| MEMORY | Memoria asignada al servidor | 1G |
| SERVER_PORT | Puerto para la versión Java | 25565 |
| GEYSER_PORT | Puerto para la versión Bedrock | 19132 |

## Despliegue en Railway

1. Crea una cuenta en [Railway](https://railway.app/) si aún no tienes una
2. Haz clic en el botón de despliegue a continuación:
   [![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/minecraft-crossplay)
3. Configura las variables de entorno según tus necesidades
4. ¡Espera a que se complete el despliegue!

## Conexión al servidor

### Java Edition
- Abre Minecraft Java Edition
- Ve a Multijugador > Añadir servidor
- Ingresa la dirección IP o dominio proporcionado por Railway

### Bedrock Edition (móvil, consolas, Windows 10/11)
- Abre Minecraft Bedrock Edition
- Ve a Jugar > Servidores
- Haz clic en "Añadir servidor"
- Ingresa un nombre para el servidor
- Ingresa la dirección IP o dominio proporcionado por Railway
- Utiliza el puerto 19132 (o el que hayas configurado en GEYSER_PORT)

## Mantenimiento

Los datos del servidor se almacenan en el contenedor. Para persistencia a largo plazo, considera configurar un volumen de almacenamiento en Railway.

## Solución de problemas

Si encuentras problemas durante la construcción o ejecución:

1. Verifica que la versión de Minecraft especificada sea compatible con Paper
2. Asegúrate de que los puertos estén correctamente configurados en Railway
3. Revisa los logs del servidor para identificar errores específicos

## Notas importantes

- El servidor utiliza Paper, que es una implementación optimizada del servidor de Minecraft
- Para el crossplay se utiliza Geyser y Floodgate, que permiten la conexión desde Bedrock Edition
- Railway proporciona una dirección IP pública y un dominio para tu servidor 