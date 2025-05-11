#!/bin/bash
set -e

# Imprimir información para depuración
echo "======= INFORMACIÓN DEL ENTORNO ======="
echo "Iniciando servidor Minecraft con Forge y mods..."
echo "SERVER_PORT: $SERVER_PORT"
echo "GEYSER_PORT: $GEYSER_PORT"
echo "MEMORY: $MEMORY"
echo "VERSION: $VERSION"
echo "FORGE_VERSION: $FORGE_VERSION"
echo "Directorio actual: $(pwd)"
echo "========================================"

# Comprobar si ya existe el mundo
if [ ! -d "/data/world" ] || [ -z "$(ls -A /data/world)" ]; then
  echo "No se encontró mundo existente, se creará uno nuevo"
else
  echo "Mundo existente encontrado en /data/world"
fi

# Descargar mods definidos en el archivo
if [ -f "$MODS_FILE" ]; then
  echo "Descargando mods desde $MODS_FILE"
  mkdir -p /data/mods
  while IFS= read -r line || [ -n "$line" ]; do
    # Ignorar líneas que comienzan con #
    if [[ $line != \#* ]] && [[ -n $line ]]; then
      echo "Descargando: $line"
      wget -q -O "/data/mods/$(basename "$line")" "$line" || echo "Error al descargar $line"
    fi
  done < "$MODS_FILE"
  echo "Mods descargados. Contenido de /data/mods:"
  ls -la /data/mods
fi

# Comprobar espacio disponible
echo "Espacio en disco disponible:"
df -h

# Comprobar memoria disponible
echo "Memoria disponible:"
free -h

# Iniciar el servidor
echo "Iniciando servidor con /start..."
exec /start

# Nota: Este código no se ejecutará si exec es exitoso
echo "El servidor terminó. Comprobando logs..."
if [ -f /data/logs/latest.log ]; then
  echo "===== ÚLTIMAS 50 LÍNEAS DEL LOG DEL SERVIDOR ====="
  tail -n 50 /data/logs/latest.log
else
  echo "No se encontró el archivo de log del servidor"
fi

# Siempre devolver éxito para que Railway no reinicie el contenedor
# (esto es para depuración únicamente - eliminar después)
exit 0 