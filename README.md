# Servidor Minecraft Multiplataforma (Java + Bedrock)

Este servidor permite jugar tanto desde Minecraft Java como desde Minecraft Bedrock (versión 1.21.80), con soporte para mods y add-ons.

## Requisitos

- Docker y Docker Compose
- Al menos 4GB de RAM disponibles
- Puertos 25565 (Java) y 19132 (Bedrock) abiertos

## Configuración Inicial

1. Clona este repositorio o descarga los archivos
2. Dale permisos de ejecución al script de configuración:
   ```bash
   chmod +x setup-mods.sh
   ```
3. Ejecuta el script de configuración:
   ```bash
   ./setup-mods.sh
   ```

## Añadir Mods (Java)

Para añadir mods compatibles con Fabric, usa el script proporcionado:

```bash
./add-mod.sh URL_DEL_MOD
```

Ejemplo:
```bash
./add-mod.sh https://cdn.modrinth.com/data/AANobbMI/versions/mc1.20.4-0.12.2/sodium-fabric-0.5.3%2Bmc1.20.4.jar
```

## Añadir Add-ons (Bedrock)

Para añadir add-ons de Bedrock, usa el script proporcionado:

```bash
./add-addon.sh URL_DEL_ADDON
```

## Mods preinstalados

- Fabric API (necesario para la mayoría de los mods)
- Geyser (compatibilidad con Bedrock)
- Floodgate (autenticación para Bedrock)

## Conexión

### Minecraft Java
- Dirección: IP_DEL_SERVIDOR
- Puerto: 25565 (predeterminado)

### Minecraft Bedrock
- Dirección: IP_DEL_SERVIDOR
- Puerto: 19132

## Comandos útiles

- Iniciar servidor: `docker-compose up -d`
- Detener servidor: `docker-compose down`
- Ver logs en tiempo real: `docker-compose logs -f`
- Reiniciar servidor: `docker-compose restart`

## Personalización

Puedes editar el archivo `docker-compose.yml` para ajustar:
- Versión de Minecraft Java
- Memoria asignada
- Dificultad
- Otras configuraciones del servidor

## Solución de problemas

Si tienes problemas con la conexión desde Bedrock:
1. Asegúrate de que el puerto 19132 UDP esté abierto en tu router/firewall
2. Verifica que la versión de tu cliente Bedrock sea 1.21.80
3. Revisar logs con `docker-compose logs -f`

## Respaldo

Los datos del servidor se guardan en la carpeta `./data`. Para hacer una copia de seguridad, simplemente copia esta carpeta.

## Notas importantes

- El modo online está desactivado (ONLINE_MODE=false) para permitir conexiones desde Bedrock. Considera añadir un plugin de autenticación si tu servidor es público.
- Si cambias la versión de Minecraft, asegúrate de que los mods sean compatibles con esa versión. 