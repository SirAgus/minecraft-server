# Servidor de Minecraft Crossplay

Este es un servidor de Minecraft que permite jugar tanto desde la versión Java como desde la versión Bedrock (móvil, consolas, Windows 10/11), diseñado para ser desplegado en Railway o ejecutado localmente.

## Características

- Soporte para Minecraft Java Edition 1.21.4
- Soporte para Minecraft Bedrock Edition (crossplay) 1.21.50-1.21.80
- Basado en la imagen oficial itzg/minecraft-server
- Incluye Geyser y Floodgate para permitir el crossplay
- Optimizado para Railway y despliegue local
- Fácil despliegue con Docker Compose
- Configuración personalizable a través de variables de entorno

## Variables de entorno

| Variable | Descripción | Valor predeterminado |
|----------|-------------|----------------------|
| VERSION | Versión de Minecraft a utilizar | 1.21.4 |
| MEMORY | Memoria asignada al servidor | 2G |
| SERVER_PORT | Puerto para la versión Java | 25565 |
| GEYSER_PORT | Puerto para la versión Bedrock | 19132 |
| DIFFICULTY | Dificultad del juego | normal |
| MAX_PLAYERS | Número máximo de jugadores | 20 |
| VIEW_DISTANCE | Distancia de renderizado | 10 |
| PLUGINS_SYNC_UPDATE | Desactiva actualización automática de plugins | false |
| COPY_PLUGINS_ONLY_IF_NEWER | Desactiva copia de plugins si ya existen | false |

## Ejecución local con Docker

```bash
# Construir y ejecutar con Docker Compose
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener el servidor
docker-compose down
```

## Despliegue en Railway

1. Crea una cuenta en [Railway](https://railway.app/) si aún no tienes una
2. Haz clic en el botón de despliegue a continuación:
   [![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/minecraft-crossplay)
3. Configura las variables de entorno según tus necesidades
4. Importante: Asegúrate de exponer tanto el puerto TCP 25565 (Java) como el puerto UDP 19132 (Bedrock)
5. ¡Espera a que se complete el despliegue!

### Nota importante para Railway
Para Railway, se utiliza una configuración especial en `railway-compose.yml` que no utiliza volúmenes persistentes para evitar errores. Los datos del servidor se mantienen dentro del contenedor mientras el servicio esté activo en Railway.

## Conexión al servidor

### Java Edition
- Abre Minecraft Java Edition 1.21.4
- Ve a Multijugador > Añadir servidor
- Ingresa la dirección IP o dominio proporcionado por Railway o tu IP local
- Puerto: 25565 (predeterminado)

### Bedrock Edition (móvil, consolas, Windows 10/11)
- Abre Minecraft Bedrock Edition (1.21.50-1.21.80)
- Ve a Jugar > Servidores
- Haz clic en "Añadir servidor"
- Ingresa un nombre para el servidor
- Ingresa la dirección IP o dominio proporcionado por Railway o tu IP local
- Puerto: 19132

## Persistencia de datos

Para ejecución local, los datos del servidor se almacenan en el volumen Docker `minecraft-data` que persiste incluso después de reiniciar el contenedor. En Railway, los datos se mantienen dentro del contenedor mientras el servicio esté activo.

## Solución de problemas

Si encuentras problemas durante la construcción o ejecución:

1. Verifica que los puertos 25565 (TCP) y 19132 (UDP) estén disponibles y correctamente expuestos
2. Asegúrate de asignar suficiente memoria al servidor (mínimo 2GB recomendado)
3. Revisa los logs del servidor para identificar errores específicos
4. Si aparece una advertencia sobre la versión Java requerida por Geyser, es normal y no afecta la funcionalidad
5. Si encuentras errores relacionados con ViaVersion o errores de plugin:
   - Asegúrate de que las variables `PLUGINS_SYNC_UPDATE=false` y `COPY_PLUGINS_ONLY_IF_NEWER=false` estén configuradas
   - Para Railway, usa la configuración especial que no utiliza volúmenes persistentes

## Notas importantes

- El servidor utiliza Paper, que es una implementación optimizada del servidor de Minecraft
- Para el crossplay se utiliza Geyser y Floodgate, que permiten la conexión desde Bedrock Edition
- Railway proporciona una dirección IP pública y un dominio para tu servidor
- En Railway, asegúrate de configurar correctamente tanto el puerto TCP (25565) como el UDP (19132) para el crossplay 