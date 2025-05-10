FROM openjdk:17-slim

WORKDIR /app

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y wget unzip curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Variables de entorno
ENV MINECRAFT_VERSION=1.20.4
ENV GEYSER_VERSION=latest
ENV FLOODGATE_VERSION=latest
ENV SERVER_PORT=25565
ENV GEYSER_PORT=19132
ENV MEMORY=1G

# Descargar el servidor de Paper (versión Java)
RUN wget -O paper.jar https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/latest/downloads/paper-${MINECRAFT_VERSION}-latest.jar

# Descargar plugins de crossplay (Geyser y Floodgate)
RUN mkdir -p /app/plugins && \
    wget -O /app/plugins/Geyser-Spigot.jar https://download.geysermc.org/v2/projects/geyser/versions/${GEYSER_VERSION}/builds/latest/downloads/spigot && \
    wget -O /app/plugins/floodgate-spigot.jar https://download.geysermc.org/v2/projects/floodgate/versions/${FLOODGATE_VERSION}/builds/latest/downloads/spigot

# Aceptar EULA automáticamente
RUN echo "eula=true" > eula.txt

# Copiar archivos de configuración
COPY server.properties /app/server.properties
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Puerto para Minecraft Java Edition
EXPOSE ${SERVER_PORT}/tcp
# Puerto para Minecraft Bedrock Edition (Geyser)
EXPOSE ${GEYSER_PORT}/udp

CMD ["/app/start.sh"] 