# Servidor Minecraft Multiplataforma (Java + Bedrock)

Este servidor permite jugar tanto desde Minecraft Java como desde Minecraft Bedrock (versión 1.21.80), con soporte para plugins y add-ons.

## Requisitos

- Docker y Docker Compose
- Al menos 4GB de RAM disponibles
- Puertos 25565 (Java) y 19132 (Bedrock) abiertos

## Configuración Inicial

1. Clona este repositorio o descarga los archivos
2. Dale permisos de ejecución a los scripts:
   ```bash
   chmod +x setup-mods.sh install-geyser.sh start.sh fix-permissions.sh
   ```
3. Ejecuta el script de configuración:
   ```bash
   ./setup-mods.sh
   ```
4. Si encuentras problemas de permisos, ejecuta:
   ```bash
   ./fix-permissions.sh
   ```
5. Para habilitar soporte de Bedrock, ejecuta:
   ```bash
   ./install-geyser.sh
   ```
6. Reinicia el servidor:
   ```bash
   docker-compose restart
   ```

## Añadir Plugins (Java)

Para añadir plugins compatibles con Paper/Spigot, usa el script proporcionado:

```bash
./add-plugin.sh URL_DEL_PLUGIN
```

Ejemplo:
```bash
./add-plugin.sh https://github.com/EssentialsX/Essentials/releases/download/2.19.7/EssentialsX-2.19.7.jar
```

## Añadir Add-ons (Bedrock)

Para añadir add-ons de Bedrock, usa el script proporcionado:

```bash
./add-addon.sh URL_DEL_ADDON
```

## Plugins preinstalados (después de ejecutar install-geyser.sh)

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
- Arreglar permisos: `./fix-permissions.sh`

## Personalización

Puedes editar el archivo `docker-compose.yml` para ajustar:
- Versión de Minecraft Java
- Memoria asignada
- Dificultad
- Otras configuraciones del servidor

## Solución de problemas

### Problemas comunes

1. **Error de acceso a archivos o permisos denegados**:
   Ejecuta el script de corrección de permisos: `./fix-permissions.sh`

2. **Problemas con la conexión desde Bedrock**:
   - Asegúrate de que el puerto 19132 UDP esté abierto en tu router/firewall
   - Verifica que la versión de tu cliente Bedrock sea compatible (1.20.x o superior)
   - Revisar logs con `docker-compose logs -f`

3. **El servidor no se inicia**:
   - Comprueba si hay errores en los logs: `docker-compose logs`
   - Verifica que todos los puertos necesarios estén disponibles
   - Reinicia el servicio de Docker: `sudo systemctl restart docker`

## Respaldo

Los datos del servidor se guardan en la carpeta `./data`. Para hacer una copia de seguridad, simplemente copia esta carpeta.

## Notas importantes

- El modo online está desactivado (ONLINE_MODE=false) para permitir conexiones desde Bedrock. Considera añadir un plugin de autenticación si tu servidor es público.
- Si cambias la versión de Minecraft, asegúrate de que los plugins sean compatibles con esa versión. 