#!/bin/bash
# Script para gestionar mods del servidor Minecraft

MODS_FILE="/var/lib/minecraft/mods.txt"
TEMP_FILE="/tmp/mods_temp.txt"

function mostrar_ayuda {
  echo "Uso: $0 [comando] [opciones]"
  echo ""
  echo "Comandos:"
  echo "  list               - Listar todos los mods instalados"
  echo "  add <url>          - Añadir un nuevo mod"
  echo "  remove <numero>    - Eliminar un mod por su número en la lista"
  echo "  clear              - Eliminar todos los mods"
  echo "  help               - Mostrar esta ayuda"
  echo ""
  echo "Ejemplos:"
  echo "  $0 list"
  echo "  $0 add https://example.com/mod.jar"
  echo "  $0 remove 3"
}

function listar_mods {
  if [ ! -f "$MODS_FILE" ]; then
    echo "No se encontró el archivo de mods en $MODS_FILE"
    return 1
  fi
  
  echo "Lista de mods configurados:"
  echo "-------------------------"
  
  contador=1
  while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line != \#* ]] && [[ -n $line ]]; then
      echo "$contador: $line"
      let contador++
    fi
  done < "$MODS_FILE"
  
  if [ $contador -eq 1 ]; then
    echo "No hay mods configurados"
  fi
}

function agregar_mod {
  local url="$1"
  
  if [ -z "$url" ]; then
    echo "Error: URL del mod no especificada"
    return 1
  fi
  
  # Crear archivo si no existe
  if [ ! -f "$MODS_FILE" ]; then
    mkdir -p "$(dirname "$MODS_FILE")"
    echo "# Lista de mods para Minecraft Forge" > "$MODS_FILE"
    echo "# Añade URLs de mods, uno por línea" >> "$MODS_FILE"
    echo "" >> "$MODS_FILE"
  fi
  
  # Verificar si el mod ya está en la lista
  if grep -q "$url" "$MODS_FILE"; then
    echo "El mod ya existe en la lista"
    return 0
  fi
  
  # Añadir el mod
  echo "$url" >> "$MODS_FILE"
  echo "Mod añadido: $url"
}

function eliminar_mod {
  local numero="$1"
  
  if [ ! -f "$MODS_FILE" ]; then
    echo "No se encontró el archivo de mods en $MODS_FILE"
    return 1
  fi
  
  if [ -z "$numero" ] || ! [[ "$numero" =~ ^[0-9]+$ ]]; then
    echo "Error: Número de mod inválido"
    return 1
  fi
  
  # Contar líneas no comentadas
  total_mods=0
  while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line != \#* ]] && [[ -n $line ]]; then
      let total_mods++
    fi
  done < "$MODS_FILE"
  
  if [ "$numero" -gt "$total_mods" ] || [ "$numero" -lt 1 ]; then
    echo "Error: El número de mod $numero está fuera de rango (1-$total_mods)"
    return 1
  fi
  
  # Encontrar y eliminar el mod
  contador=0
  > "$TEMP_FILE"
  
  while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line != \#* ]] && [[ -n $line ]]; then
      let contador++
      if [ "$contador" -ne "$numero" ]; then
        echo "$line" >> "$TEMP_FILE"
      else
        mod_eliminado="$line"
      fi
    else
      echo "$line" >> "$TEMP_FILE"
    fi
  done < "$MODS_FILE"
  
  mv "$TEMP_FILE" "$MODS_FILE"
  echo "Mod eliminado: $mod_eliminado"
}

function limpiar_mods {
  if [ ! -f "$MODS_FILE" ]; then
    echo "No se encontró el archivo de mods en $MODS_FILE"
    return 1
  fi
  
  # Mantener solo las líneas de comentarios
  > "$TEMP_FILE"
  while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line == \#* ]] || [[ -z $line ]]; then
      echo "$line" >> "$TEMP_FILE"
    fi
  done < "$MODS_FILE"
  
  mv "$TEMP_FILE" "$MODS_FILE"
  echo "Se han eliminado todos los mods"
}

# Procesar comandos
comando="$1"
shift

case "$comando" in
  list|ls)
    listar_mods
    ;;
  add)
    agregar_mod "$1"
    ;;
  remove|rm)
    eliminar_mod "$1"
    ;;
  clear)
    limpiar_mods
    ;;
  help|-h|--help)
    mostrar_ayuda
    ;;
  *)
    echo "Comando desconocido: $comando"
    mostrar_ayuda
    exit 1
    ;;
esac

exit 0 