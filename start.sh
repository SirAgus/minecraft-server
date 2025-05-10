#!/bin/bash

# Configurar variables desde el entorno o usar valores predeterminados
MEMORY=${MEMORY:-1G}
SERVER_PORT=${SERVER_PORT:-25565}
GEYSER_PORT=${GEYSER_PORT:-19132}

# Reemplazar variables en server.properties
sed -i "s/\${SERVER_PORT}/${SERVER_PORT}/g" /app/server.properties

# Configurar Geyser para el crossplay
mkdir -p /app/plugins/Geyser-Spigot/
cat > /app/plugins/Geyser-Spigot/config.yml << EOL
bedrock:
  address: 0.0.0.0
  port: ${GEYSER_PORT}
  clone-remote-port: false
  motd1: "Minecraft Crossplay Server"
  motd2: "Powered by Geyser"
remote:
  address: 127.0.0.1
  port: ${SERVER_PORT}
  auth-type: online
EOL

# Iniciar el servidor de Minecraft
exec java -Xms${MEMORY} -Xmx${MEMORY} -XX:+UseG1GC -XX:+ParallelRefProcEnabled \
  -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC \
  -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \
  -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
  -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 \
  -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem \
  -XX:MaxTenuringThreshold=1 -jar paper.jar --nogui 