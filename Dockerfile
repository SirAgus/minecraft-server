FROM itzg/minecraft-server:java21

# Variables de entorno para configurar el servidor
ENV TYPE=PAPER
ENV VERSION=1.21.4
ENV MEMORY=2G
ENV EULA=TRUE
ENV SERVER_PORT=25565
ENV ONLINE_MODE=true
ENV DIFFICULTY=normal
ENV ALLOW_NETHER=true
ENV ENABLE_COMMAND_BLOCK=true
ENV LEVEL_TYPE=default
ENV PVP=true
ENV MAX_PLAYERS=20
ENV VIEW_DISTANCE=10
ENV SPAWN_PROTECTION=16
ENV GENERATE_STRUCTURES=true
ENV SPAWN_ANIMALS=true
ENV SPAWN_MONSTERS=true
ENV SPAWN_NPCS=true
ENV RATE_LIMIT=0

# Variables para Geyser y Floodgate (crossplay)
ENV GEYSER=true
ENV GEYSER_PORT=19132
ENV FLOODGATE=true

# Variables para plugins - Solución para problemas de sincronización
ENV PLUGINS_SYNC_UPDATE=false
ENV COPY_PLUGINS_ONLY_IF_NEWER=false
ENV SYNC_SKIP_NEWER_IN_DESTINATION=true
ENV PLUGINS=https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot,https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot,https://github.com/ViaVersion/ViaVersion/releases/download/5.3.2/ViaVersion-5.3.2.jar

# Instalar herramientas de depuración
RUN apt-get update && apt-get install -y procps

# Crear directorios necesarios
RUN mkdir -p /config/plugins/Geyser-Spigot

# Copiar archivos de configuración personalizados
COPY start.sh /start-custom.sh
COPY server.properties /defaults/server.properties
COPY geyser-config.yml /config/plugins/Geyser-Spigot/config.yml
RUN chmod +x /start-custom.sh

# Configurar puertos
EXPOSE ${SERVER_PORT}/tcp
EXPOSE ${GEYSER_PORT}/tcp
EXPOSE ${GEYSER_PORT}/udp

# Usar nuestro script personalizado como punto de entrada
ENTRYPOINT ["/start-custom.sh"] 