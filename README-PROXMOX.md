# Servidor Minecraft Forge para Proxmox

Este es un servidor de Minecraft con Forge y soporte para mods, diseñado para ser ejecutado en un entorno Proxmox.

## Requisitos
- Proxmox VE 7.0 o superior
- Docker y Docker Compose instalados en el contenedor o VM
- Mínimo 4GB de RAM dedicada
- Al menos 10GB de espacio en disco

## Instalación

### 1. Preparar el entorno en Proxmox

1. Crear un contenedor LXC o una VM en Proxmox
2. Instalar Docker y Docker Compose:

```bash
apt-get update
apt-get install -y docker.io docker-compose git
```

### 2. Clonar el repositorio

```bash
git clone <url-del-repositorio> /opt/minecraft-server
cd /opt/minecraft-server
```

### 3. Configurar el mundo personalizado

Crea los directorios necesarios:

```bash
mkdir -p /var/lib/minecraft/data
mkdir -p /var/lib/minecraft/world
```

Si tienes un mundo existente, cópialo a `/var/lib/minecraft/world`:

```bash
# Ejemplo: Descomprimir un mundo desde un archivo ZIP
unzip mi-mundo.zip -d /var/lib/minecraft/world
```

### 4. Configurar mods

Crea un archivo de mods personalizado:

```bash
nano /var/lib/minecraft/mods.txt
```

Añade las URLs de los mods que deseas instalar, uno por línea:

```
https://mediafilez.forgecdn.net/files/4582/674/journeymap-1.20.1-5.9.18-forge.jar
https://mediafilez.forgecdn.net/files/4978/962/jei-1.20.1-forge-15.3.0.4.jar
# Agrega más mods según necesites
```

### 5. Iniciar el servidor

```bash
cd /opt/minecraft-server
docker-compose -f docker-compose-proxmox.yml up -d
```

## Gestión del servidor

### Ver logs del servidor
```bash
docker logs -f minecraft-server
```

### Detener el servidor
```bash
docker-compose -f docker-compose-proxmox.yml down
```

### Reiniciar el servidor
```bash
docker-compose -f docker-compose-proxmox.yml restart
```

### Acceder a la consola del servidor
```bash
docker exec -it minecraft-server rcon-cli
```

## Características

- **Forge**: Compatible con mods de Forge 1.20.1
- **Geyser/Floodgate**: Permite la conexión desde Minecraft Bedrock (móviles, consolas)
- **Optimización para Proxmox**: Configuración recomendada para entornos virtualizados
- **Mundo personalizado**: Permite usar un mundo ya existente
- **Mod loader automático**: Descarga y configura los mods especificados automáticamente

## Solución de problemas

- Si el servidor no inicia, verifica los logs con `docker logs minecraft-server`
- Asegúrate de que los mods sean compatibles con la versión de Forge especificada
- Verifica que el mundo sea compatible con la versión de Minecraft configurada 