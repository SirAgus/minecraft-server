# Servidor Minecraft Forge para Proxmox

Este es un servidor de Minecraft con Forge y soporte para mods, diseñado para ser ejecutado en un entorno Proxmox. Compatible con Minecraft Java 1.21.4 y Bedrock 1.21.80.

## Requisitos
- Proxmox VE 7.0 o superior
- Docker y Docker Compose instalados en el contenedor o VM
- Mínimo 4GB de RAM dedicada
- Al menos 10GB de espacio en disco

## Instalación rápida

La forma más rápida de instalar es usando el script de instalación automática:

```bash
# Clonar el repositorio
git clone <url-del-repositorio> /tmp/minecraft-server
cd /tmp/minecraft-server

# Ejecutar el script de instalación
sudo ./proxmox-setup.sh
```

## Instalación manual

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

Puedes usar el script `prepare-world.sh` para preparar un mundo existente:

```bash
# Con un archivo ZIP del mundo
sudo ./prepare-world.sh mi-mundo.zip

# Con un directorio existente
sudo ./prepare-world.sh ./mi-mundo-folder
```

O hacerlo manualmente:

```bash
mkdir -p /var/lib/minecraft/data
mkdir -p /var/lib/minecraft/world
unzip mi-mundo.zip -d /var/lib/minecraft/world
chown -R 1000:1000 /var/lib/minecraft/world
```

### 4. Configurar mods

Puedes usar el script `manage-mods.sh` para gestionar los mods:

```bash
# Listar mods configurados
sudo ./manage-mods.sh list

# Añadir un nuevo mod
sudo ./manage-mods.sh add https://example.com/ruta/al/mod.jar

# Eliminar un mod (por número)
sudo ./manage-mods.sh remove 2

# Eliminar todos los mods
sudo ./manage-mods.sh clear
```

O configurar manualmente:

```bash
nano /var/lib/minecraft/mods.txt
# Añadir URLs de los mods, uno por línea
```

### 5. Iniciar el servidor

```bash
cd /opt/minecraft-server
docker-compose up -d
```

## Gestión del servidor

### Ver logs del servidor
```bash
docker logs -f minecraft-server
```

### Detener el servidor
```bash
docker-compose down
```

### Reiniciar el servidor
```bash
docker-compose restart
```

### Acceder a la consola del servidor
```bash
docker exec -it minecraft-server rcon-cli
```

## Características

- **Forge**: Compatible con mods de Forge 1.21.4
- **Geyser/Floodgate**: Permite la conexión desde Minecraft Bedrock 1.21.80
- **Optimización para Proxmox**: Configuración recomendada para entornos virtualizados
- **Mundo personalizado**: Permite usar un mundo ya existente
- **Mod loader automático**: Descarga y configura los mods especificados automáticamente

## Solución de problemas

- Si el servidor no inicia, verifica los logs con `docker logs minecraft-server`
- Asegúrate de que los mods sean compatibles con la versión de Forge especificada (1.21.4)
- Verifica que el mundo sea compatible con la versión de Minecraft configurada 

### Problemas de conectividad y DNS

Si encuentras problemas de resolución de nombres o de conexión a Internet durante la instalación, puedes seguir estos pasos:

1. Configura los servidores DNS manualmente:
```bash
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
```

2. Verifica la conectividad básica a Internet:
```bash
ping -c 4 8.8.8.8
```

3. Si los problemas persisten, verifica la configuración de red en Proxmox:
   - Asegúrate de que el contenedor/VM tenga una dirección IP válida
   - Verifica que el gateway esté configurado correctamente
   - Comprueba que no haya reglas de firewall bloqueando la conexión

4. Si usas NetworkManager, reinicia el servicio:
```bash
systemctl restart NetworkManager
```

## Configuración Cross-Platform (Java + Bedrock)

Este servidor está configurado para permitir conexiones tanto desde Minecraft Java Edition (1.21.5) como desde Minecraft Bedrock Edition usando GeyserMC.

### Instrucciones para conexión multiplataforma

1. El servidor usa Paper (una versión optimizada de Spigot) con los plugins Geyser y Floodgate.
2. Para que funcione correctamente, asegúrate de crear el directorio de configuración para Geyser:

```bash
# Crear directorio para la configuración de Geyser
sudo mkdir -p /var/lib/minecraft/data/plugins/Geyser-Spigot

# Copiar archivo de configuración
sudo cp /opt/minecraft-server/geyser-config/config.yml /var/lib/minecraft/data/plugins/Geyser-Spigot/

# Establecer permisos
sudo chmod -R 777 /var/lib/minecraft/data/plugins
```

3. **Para conectarte desde Java Edition**: Usa la IP del servidor y puerto 25565
4. **Para conectarte desde Bedrock Edition**: Usa la misma IP y puerto 25566

### Solución de problemas

Si tienes problemas con la conexión desde Bedrock:

```bash
# Verificar que Geyser se ha cargado correctamente
sudo docker logs minecraft-server | grep -i geyser

# Si no aparece, reinicia el servidor
sudo docker-compose restart minecraft-server
``` 