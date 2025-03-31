#!/bin/bash

# === CONFIGURACIÓN ===
DIR="/home/kenny/Downloads"
LOGDIR="/home/kenny/mi-primer-repo-git/logs"
LOG="$LOGDIR/limpieza.log"
FECHA=$(date '+%F %T')

# === CREAR DIRECTORIO SI NO EXISTE ===
mkdir -p "$LOGDIR"

# === INICIAR LOG ===
echo -e "\n🧹 Limpieza iniciada: $FECHA" >> "$LOG"

# === BUSCAR ARCHIVOS TEMPORALES A ELIMINAR ===
ARCHIVOS_ELIMINADOS=$(find "$DIR" -type f \( -name "*.tmp" -o -name "*.log" -o -size +100M \))

# === SI HAY ARCHIVOS A ELIMINAR, PROCESAR ===
if [ -n "$ARCHIVOS_ELIMINADOS" ]; then
    echo "$ARCHIVOS_ELIMINADOS" >> "$LOG"
    echo "$ARCHIVOS_ELIMINADOS" | xargs rm -f
    echo "✅ Limpieza completada: $(date '+%F %T')" >> "$LOG"

    # === ENVIAR CORREO CON LISTA DE ARCHIVOS ===
    echo -e "🚨 Se eliminaron los siguientes archivos temporales en $DIR:\n\n$ARCHIVOS_ELIMINADOS" \
    | mail -s "🧹 Limpieza realizada - Archivos eliminados" mario.villaverdebaron6@gmail.com
else
    echo "ℹ️ No se encontraron archivos para limpiar." >> "$LOG"
fi
