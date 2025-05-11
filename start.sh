#!/bin/bash
set -e

# Imprimir información para depuración
echo "======= INFORMACIÓN DEL ENTORNO ======="
echo "Iniciando servidor Minecraft..."
echo "SERVER_PORT: $SERVER_PORT"
echo "GEYSER_PORT: $GEYSER_PORT"
echo "MEMORY: $MEMORY"
echo "Directorio actual: $(pwd)"
echo "Contenido de /data:"
ls -la /data
echo "Contenido de /data/plugins:"
ls -la /data/plugins || echo "No existe el directorio de plugins"
echo "========================================"

# Comprobar espacio disponible
echo "Espacio en disco disponible:"
df -h

# Comprobar memoria disponible
echo "Memoria disponible:"
free -h

# Intento de ejecutar el comando con captura de errores
echo "Iniciando servidor con /start..."
/start 2>&1 || echo "Error al iniciar el servidor: código de salida $?"

# Si llegamos aquí, es que el servidor falló
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