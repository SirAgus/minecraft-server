FROM eclipse-temurin:21-jre

WORKDIR /app

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y wget unzip curl jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Variables de entorno
ENV MINECRAFT_VERSION=1.21.4
ENV GEYSER_VERSION=latest
ENV FLOODGATE_VERSION=latest
ENV SERVER_PORT=25565
ENV GEYSER_PORT=19132
ENV MEMORY=1G

# Descargar el servidor de Paper usando la estructura correcta de API
RUN LATEST_BUILD=$(wget -qO- https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds | jq -r '.builds | map(select(.channel == "default") | .build) | .[-1]') && \
    JAR_NAME=paper-${MINECRAFT_VERSION}-${LATEST_BUILD}.jar && \
    DOWNLOAD_URL=https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${LATEST_BUILD}/downloads/${JAR_NAME} && \
    wget -O paper.jar ${DOWNLOAD_URL}

# Descargar plugins de crossplay (Geyser y Floodgate)
RUN mkdir -p /app/plugins && \
    wget -O /app/plugins/Geyser-Spigot.jar https://download.geysermc.org/v2/projects/geyser/versions/${GEYSER_VERSION}/builds/latest/downloads/spigot && \
    wget -O /app/plugins/floodgate-spigot.jar https://download.geysermc.org/v2/projects/floodgate/versions/${FLOODGATE_VERSION}/builds/latest/downloads/spigot

# Aceptar el EULA
RUN echo "eula=true" > /app/eula.txt

# Copiar archivos de configuración
COPY server.properties /app/server.properties
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Puerto para la versión Java
EXPOSE ${SERVER_PORT}
# Puerto para la versión Bedrock
EXPOSE ${GEYSER_PORT}/udp

# Iniciar el servidor
CMD ["/app/start.sh"] 