#!/bin/bash
# Script para gestionar mods del servidor Minecraft
# Uso: ./manage-mods.sh [list|add|remove|clear]

# Definir archivo de mods y colores para salida
MODS_FILE="/var/lib/minecraft/mods.txt"
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verificar privilegios de root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Este script debe ejecutarse como root${NC}"
  exit 1
fi

# Función para mostrar el uso del script
show_usage() {
  echo -e "${BLUE}Gestor de Mods para Servidor Minecraft${NC}"
  echo ""
  echo -e "Uso: ${YELLOW}$0 COMANDO [ARGUMENTOS]${NC}"
  echo ""
  echo "Comandos disponibles:"
  echo -e "  ${GREEN}list${NC}             Listar mods configurados actualmente"
  echo -e "  ${GREEN}add URL${NC}          Añadir un nuevo mod usando su URL de descarga"
  echo -e "  ${GREEN}remove NÚMERO${NC}    Eliminar un mod por su número en la lista"
  echo -e "  ${GREEN}clear${NC}            Eliminar todos los mods configurados"
  echo ""
  echo "Ejemplos:"
  echo -e "  ${YELLOW}$0 list${NC}"
  echo -e "  ${YELLOW}$0 add https://example.com/ruta/al/mod.jar${NC}"
  echo -e "  ${YELLOW}$0 remove 2${NC}"
  echo ""
}

# Función para listar los mods configurados
list_mods() {
  echo -e "${BLUE}=== Mods configurados ===${NC}"
  
  # Verificar si el archivo existe y tiene contenido
  if [ ! -f "$MODS_FILE" ] || [ ! -s "$MODS_FILE" ] || [ -z "$(grep -v '^#' "$MODS_FILE")" ]; then
    echo -e "${YELLOW}No hay mods configurados${NC}"
    return
  fi

  # Mostrar mods con números de línea, excluyendo comentarios
  local mod_number=1
  while IFS= read -r line; do
    # Ignorar líneas que comienzan con # (comentarios)
    if [[ ! $line =~ ^[[:space:]]*# ]] && [[ -n $line ]]; then
      echo -e "${GREEN}$mod_number)${NC} $line"
      ((mod_number++))
    fi
  done < <(grep -v '^[[:space:]]*$' "$MODS_FILE" | grep -v '^[[:space:]]*#')

  # Si no encontramos mods (solo comentarios)
  if [ "$mod_number" -eq 1 ]; then
    echo -e "${YELLOW}No hay mods configurados${NC}"
  fi
}

# Función para añadir un nuevo mod
add_mod() {
  local url="$1"
  
  # Validar URL
  if [ -z "$url" ]; then
    echo -e "${RED}Error: URL no especificada${NC}"
    show_usage
    return 1
  fi

  # Validar formato de URL
  if [[ ! $url =~ ^https?:// ]]; then
    echo -e "${RED}Error: URL inválida. Debe comenzar con http:// o https://${NC}"
    return 1
  fi

  # Verificar si el archivo existe, si no, crearlo
  if [ ! -f "$MODS_FILE" ]; then
    echo "# Lista de mods para Minecraft Forge" > "$MODS_FILE"
    echo "# Añade URLs de los mods, uno por línea" >> "$MODS_FILE"
    echo "" >> "$MODS_FILE"
  fi

  # Verificar si el mod ya está en la lista
  if grep -q "$url" "$MODS_FILE"; then
    echo -e "${YELLOW}El mod ya está en la lista${NC}"
    return
  fi

  # Añadir el mod al archivo
  echo "$url" >> "$MODS_FILE"
  echo -e "${GREEN}Mod añadido correctamente${NC}"
  
  # Opcional: Mostrar lista actualizada
  echo ""
  list_mods
}

# Función para eliminar un mod por número
remove_mod() {
  local mod_number="$1"
  
  # Validar número
  if [ -z "$mod_number" ] || ! [[ "$mod_number" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}Error: Debes especificar un número válido${NC}"
    show_usage
    return 1
  fi

  # Verificar si el archivo existe
  if [ ! -f "$MODS_FILE" ] || [ ! -s "$MODS_FILE" ]; then
    echo -e "${RED}No hay mods configurados para eliminar${NC}"
    return 1
  fi

  # Obtener la lista de mods (sin comentarios ni líneas vacías)
  local mods_list=($(grep -v '^[[:space:]]*#' "$MODS_FILE" | grep -v '^[[:space:]]*$'))
  
  # Verificar si el número es válido
  if [ "$mod_number" -lt 1 ] || [ "$mod_number" -gt "${#mods_list[@]}" ]; then
    echo -e "${RED}Error: Número de mod inválido. Debe estar entre 1 y ${#mods_list[@]}${NC}"
    return 1
  fi

  # Obtener URL del mod a eliminar (los arrays empiezan en 0)
  local mod_to_remove="${mods_list[$mod_number-1]}"
  
  # Crear archivo temporal sin el mod
  grep -v "$mod_to_remove" "$MODS_FILE" > "$MODS_FILE.tmp"
  mv "$MODS_FILE.tmp" "$MODS_FILE"
  
  echo -e "${GREEN}Mod eliminado correctamente${NC}"
  
  # Mostrar lista actualizada
  echo ""
  list_mods
}

# Función para eliminar todos los mods
clear_mods() {
  # Pedir confirmación
  read -p "¿Estás seguro de querer eliminar TODOS los mods? (s/N): " confirm
  if [[ ! $confirm =~ ^[Ss]$ ]]; then
    echo -e "${YELLOW}Operación cancelada${NC}"
    return
  fi

  # Mantener solo las líneas de comentarios
  grep '^#' "$MODS_FILE" > "$MODS_FILE.tmp" 2>/dev/null || echo "# Lista de mods para Minecraft Forge" > "$MODS_FILE.tmp"
  mv "$MODS_FILE.tmp" "$MODS_FILE"
  
  echo -e "${GREEN}Todos los mods han sido eliminados${NC}"
}

# Procesar comandos
case "$1" in
  list)
    list_mods
    ;;
  add)
    add_mod "$2"
    ;;
  remove)
    remove_mod "$2"
    ;;
  clear)
    clear_mods
    ;;
  *)
    show_usage
    ;;
esac 